local _config = {
    server = {
        nginx = {
            port = "8080"
        }
    },
    templates = {},
    apps = {
        welcome = "apps/welcome",
    },
    supervisor = [[
    ]]
}
return _config
