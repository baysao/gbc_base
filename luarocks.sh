v=3.12.1
wget http://luarocks.org/releases/luarocks-$v.tar.gz
tar -xzvf luarocks-$v.tar.gz
cd luarocks-$v/
./configure --prefix=/usr/local/openresty/luajit \
    --with-lua=/usr/local/openresty/luajit/ \
    --lua-suffix=jit \
    --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
make
sudo make install
sudo apt-get install libssl-dev
sudo /usr/local/openresty/luajit/bin/luarocks install lapis
