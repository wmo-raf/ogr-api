const logger = require("logger");
const path = require("path");
const Koa = require("koa");
const koaLogger = require("koa-logger");
const loader = require("loader");
const koaValidate = require("koa-validate");
const koaBody = require("koa-body");
const cors = require("@koa/cors");
const koaSimpleHealthCheck = require("koa-simple-healthcheck");
const ErrorSerializer = require("serializers/errorSerializer");

// instance of koa
const app = new Koa();

// CORS
app.use(cors());

app.use(koaLogger());

app.use(async (ctx, next) => {
    try {
        await next();
    } catch (inErr) {
        let error = inErr;
        try {
            error = JSON.parse(inErr);
        } catch (e) {
            logger.debug(
                "Could not parse error message - is it JSON?: ",
                inErr
            );
            error = inErr;
        }
        ctx.status = error.status || ctx.status || 500;
        if (ctx.status >= 500) {
            logger.error(error);
        } else {
            logger.info(error);
        }

        ctx.body = ErrorSerializer.serializeError(ctx.status, error.message);
        if (process.env.NODE_ENV === "prod" && ctx.status === 500) {
            ctx.body = "Unexpected error";
        }
        ctx.response.type = "application/vnd.api+json";
    }
});

app.use(
    koaBody({
        multipart: true,
        formidable: {
            uploadDir: "/tmp",
            onFileBegin(name, file) {
                const folder = path.dirname(file.path);
                file.path = path.join(folder, file.name);
            },
        },
    })
);

// load custom validator
koaValidate(app);

app.use(koaSimpleHealthCheck());

// load routes
loader.loadRoutes(app);

const port = process.env.PORT || 3000;

const server = app.listen(port, () => {});

logger.info(`Server started in port:${port}`);

module.exports = server;
