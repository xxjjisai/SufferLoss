
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "socket"
require 'app.Common'
require "app.Camp"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end