
if [[ "`ps -ef | grep remixd | grep -v grep`" != "" ]]; then
  ps -ef | grep remixd | grep -v grep | awk '{print $2}' | xargs kill -9
fi
remixd -s "`pwd`/contract/" --remix-ide 'http://127.0.0.1:8080' &

docker run -p 8080:80 remixproject/remix-ide:remix_live

