local _config = {
    server = {
        nginx = {
            port = "8080"
        }
    },
    templates = {},
    apps = {
        client = "apps/client",
        -- welcome = "apps/welcome",
    },
    supervisor = [[
    ]]
}
return _config
