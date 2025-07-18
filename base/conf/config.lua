--[[

Copyright (c) 2015 gameboxcloud.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]
local config = {
    DEBUG = cc.DEBUG_VERBOSE,
    SITES_DIR = "_GBC_CORE_ROOT_/sites",
    -- default app config
    app = {
        appIndex = 1,
        messageFormat = "json",
        defaultAcceptedRequestType = "http",
        sessionExpiredTime = 60 * 30, -- 10m
        httpEnabled = true,
        httpMessageFormat = "json",
        websocketEnabled = true,
        websocketMessageFormat = "json",
        websocketsTimeout = 60 * 1000, -- 60s
        websocketsMaxPayloadLen = 16 * 1024, -- 16KB
        jobMessageFormat = "json",
        numOfJobWorkers = 0,
        jobWorkerRequests = 1000
    },
    -- server config
    server = {
        nginx = {
            numOfWorkers = "auto",
            port = 80
        },
        -- internal memory database
        redis = {
            socket = "unix:/tmp/app/redis.sock",
            -- host = "127.0.0.1",
            port = 0,
            timeout = 120 -- 10 seconds
        },
        ssdb = {
            host = "127.0.0.1",
            port = 8888,
            timeout = 120 -- 10 seconds
        },
        -- background job server
        beanstalkd = {
	   --host         = "127.0.0.1",
            host = "unix:/tmp/app/beanstalkd.sock",
            port = 11300
        }
    }
}

return config
