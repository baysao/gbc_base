#/bin/bash

if [ "$ROOT_DIR" == "" ]; then
	echo "Not set ROOT_DIR, exit."
	exit 1
fi

# echo -e "\033[31mROOT_DIR\033[0m=$ROOT_DIR"
# echo ""

#cd $ROOT_DIR

LUA_BIN=/usr/local/openresty/luajit/bin/luajit

# TMP_DIR=$ROOT_DIR/tmp
TMP_DIR=/tmp/app
CONF_DIR=$ROOT_DIR/conf
CONF_PATH=$CONF_DIR/config.lua
VAR_SUPERVISORD_CONF_PATH=$TMP_DIR/supervisord.conf

# if [ -e "$ROOT_DIR/bin/openresty" ]; then
# 	ln -sf $ROOT_DIR/bin/openresty /usr/local/openresty
# 	cp -rf $ROOT_DIR/gbc/openresty/luajit/share/lua/5.1/* $ROOT_DIR/bin/openresty/luajit/share/lua/5.1/
# 	cp -rf $ROOT_DIR/gbc/openresty/luajit/lib/lua/5.1/* $ROOT_DIR/bin/openresty/luajit/lib/lua/5.1/
# 	echo $(realpath $(realpath $ROOT_DIR/bin/openresty)/..)/lib >/etc/ld.so.conf.d/0openresty.conf
# 	ldconfig
# 	export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$ROOT_DIR/bin/openresty/bin:$ROOT_DIR/bin/openresty/luajit/bin:$ROOT_DIR/bin/openresty/nginx/sbin
# else
# 	echo "Missing $ROOT_DIR/bin/openresty"
# 	exit 1

# fi

# if [ ! -f "/usr/bin/python" ]; then
# 	apt update
# 	apt install -y python-is-python2
# fi

# function getOsType()
# {
#     if [ `uname -s` == "Darwin" ]; then
#         echo "MACOS"
#     else
#         echo "LINUX"
#     fi
# }

# OS_TYPE=$(getOsType)
# if [ $OS_TYPE == "MACOS" ]; then
#     SED_BIN='sed -i --'
# else
SED_BIN='sed -i'
#fi

function updateConfigs() {
	# if [ ! -f "/tmp/updateconfig.lock" ]; then
	# 	touch /tmp/updateconfig.lock
	# echo "ROOT_DIR:$ROOT_DIR"
	if [ -z "$BIND_ADDRESS" ]; then BIND_ADDRESS="0.0.0.0"; fi
	$LUA_BIN -e "BIND_ADDRESS=\"$BIND_ADDRESS\";ROOT_DIR='$ROOT_DIR'; DEBUG=$DEBUG; dofile('$ROOT_DIR/bin/shell_func.lua'); updateConfigs()"
	# 	rm /tmp/updateconfig.lock
	# fi
}

function startSupervisord() {
	echo "[CMD] supervisord -n -c $VAR_SUPERVISORD_CONF_PATH"
	echo ""
	cd $ROOT_DIR/bin/python_env/gbc
	source bin/activate
	$ROOT_DIR/bin/python_env/gbc/bin/supervisord -n -c $VAR_SUPERVISORD_CONF_PATH
	cd $ROOT_DIR
	echo "Start supervisord DONE"
	echo ""

}

function stopSupervisord() {
	echo "[CMD] supervisorctl -c $VAR_SUPERVISORD_CONF_PATH shutdown"
	echo ""
	cd $ROOT_DIR/bin/python_env/gbc
	source bin/activate
	$ROOT_DIR/bin/python_env/gbc/bin/supervisorctl -c $VAR_SUPERVISORD_CONF_PATH shutdown
	cd $ROOT_DIR
	echo ""
}

function checkStatus() {
	cd $ROOT_DIR/bin/python_env/gbc
	source bin/activate
	$ROOT_DIR/bin/python_env/gbc/bin/supervisorctl -c $VAR_SUPERVISORD_CONF_PATH status
	cd $ROOT_DIR
	echo ""
}
