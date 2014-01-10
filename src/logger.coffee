util = require('util')
_ = require('underscore')

timestamp = () -> 
    t = (new Date()).toUTCString()
    return "[#{t}] - "

formatMessage = (messages...) -> 
    message = timestamp()
    _.each(messages, (m) -> message += "#{m}\n" )
    return message

LABEL_INFO = "\x1b[36m[info]\x1b[0m"
LABEL_ERROR = "\x1b[31m[error]\x1b[0m"

logger = {
    init: () ->
        process.on('uncaughtException', () ->
            @logError(err)
            process.exit(1)
        )

    logInfo: (info, context) -> 
        params = [
            if (info instanceof String) then info else util.inspect(info)
        ]
        
        if context
            params.push(util.inspect(context))

        console.log(LABEL_INFO+formatMessage.apply(null, params))


    logError: (error, context) ->
        params = []

        if (error instanceof Error)
            message = error.message
            stack = error.stack
        else
            message = if (error instanceof String) \ 
                then error else util.inspect(error)
            stack = (new Error()).stack

        params = [message, stack]

        if context
            params.push(util.inspect(context))

        console.error(LABEL_ERROR+formatMessage.apply(null, params))

}


module.exports = logger