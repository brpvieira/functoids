util = require('util')
_ = require('underscore')

timestamp = () -> 
    t = (new Date()).toUTCString()
    return "[#{t}] - "

formatMessage = (messages...) -> 
    message = timestamp() + messages.join('\n')
    return message

LABEL_INFO = "\x1b[36m[info]\x1b[0m"
LABEL_ERROR = "\x1b[31m[error]\x1b[0m"

logger = {
    logInit: () ->
        if process?
            process.on('uncaughtException', (err) =>
                @logError(err)
                process.exit(1)
            )

    logAll: (message) ->
        console.log(LABEL_INFO+formatMessage.call(null, message))
        console.error(LABEL_INFO+formatMessage.call(null, message))

    logInfo: (info, context) -> 
        params = [
            if _.isString(info) then info else util.inspect(info)
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
            message = if _.isString(error) \ 
                then error else util.inspect(error)
            stack = (new Error()).stack

        params = [message, stack]

        if context
            params.push(util.inspect(context))

        console.error(LABEL_ERROR+formatMessage.apply(null, params))

}


module.exports = logger