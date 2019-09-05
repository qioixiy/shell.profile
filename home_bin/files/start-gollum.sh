docker run -d -it --name gollum -P -p 4567:4567 \
       -v $HOME/zspace/notes:/gollum/ \
       --privileged=true registry.cn-hangzhou.aliyuncs.com/ilanni/gollum \
       --allow-uploads --live-preview \
#       --no-edit
