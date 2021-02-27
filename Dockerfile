FROM liuderchi/jupyterlab-ijavascript:py3-py2-node10

WORKDIR /data
ENV HOME=/root

RUN set -ex && \
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
apk add --no-cache bash git openssh && \
npm config set prefix $HOME && \
npm install -g itypescript --registry=https://registry.npm.taobao.org --unsafe-perm && \
~/bin/its --install=local && \
git clone https://github.com/awamwang/code-tell-you-javascript.git && \
/bin/sh -c pip install --upgrade pip && \
/bin/sh -c python3 -m pip install jupyterlab && \
jupyter lab --generate-config && \
jupyter labextension install @jupyterlab/git

COPY docker/.jupyter/user-setting/ $HOME/.jupyter/user-setting/

ENV SERVER_PORT=8888
EXPOSE $SERVER_PORT
VOLUME [ "${HOME}/.jupyter/", "/data/" ]

ENTRYPOINT ["/bin/sh", "-c", "jupyter lab --ip=* \
--port=$SERVER_PORT \
--no-browser \
--notebook-dir=/data/code-tell-you-javascript \
--allow-root"]