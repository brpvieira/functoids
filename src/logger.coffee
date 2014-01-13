util = require('util')
_ = require('underscore')

timestamp = () ->
    t = (new Date()).toUTCString()
    return "[#{t}] - "

formatMessage = (messages...) ->
    message = timestamp() + messages.join('\n')
    return message

getLogString = (message) ->
    return if _.isString(message) then message else util.inspect(message)

LABEL_INFO = "\x1b[36m[info]\x1b[0m"
LABEL_ERROR = "\x1b[31m[error]\x1b[0m"

logger = {
    logInit: () ->
        process.on('uncaughtException', (err) =>
            @logError(err)
            process.exit(1)
        )

    logAll: (message) ->
        message =  getLogString(message)
        message = LABEL_INFO + formatMessage.call(null, message)

        process.stdout.write("#{message}\n")
        process.stderr.write("#{message}\n")


    logInfo: (info, context) ->
        params = [
            getLogString(info)
        ]
        
        if context
            params.push(util.inspect(context))

        message = LABEL_INFO + formatMessage.apply(null, params)

        process.stdout.write("#{message}\n")


    logError: (error, context) ->
        params = []

        if (error instanceof Error)
            message = error.message
            stack = error.stack
        else
            message = getLogString(error)
            stack = (new Error()).stack

        params = [message, stack]

        if context?
            params.push(util.inspect(context))

        message = LABEL_ERROR + formatMessage.apply(null, params)

        process.stderr.write("#{message}\n")

}


module.exports = logger
