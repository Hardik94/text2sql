FROM jupyter/base-notebook:x86_64-ubuntu-22.04 as builder

ARG ENVIRONMENT=development
ARG ACH_DB
ARG ACH_PASSWD
ARG ACH_HOST
ARG ACH_PORT
ARG ACH_USER

ENV CH_USER=$APP_USER
ENV CH_PASSWD=$APP_PASS
ENV CH_DB=$ACH_DB
ENV CH_HOST=$ACH_HOST
ENV CH_PORT=$ACH_PORT
ENV ENVIRONMENT=$ENVIRONMENT
ENV CONNECTION="clickhouse://$CH_USER:$CH_PASSWD@$CH_HOST:$CH_PORT/$CH_DB"

USER 0

RUN pip install --no-cache-dir pandas scikit-learn transformers clickhouse-driver
RUN pip install --no-cache-dir --quiet jupysql clickhouse_sqlalchemy jupyter-ai 
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

RUN rm -rf /root/.cache

RUN python -c "from transformers import AutoTokenizer, AutoModelForSeq2SeqLM; \
                AutoTokenizer.from_pretrained('gaussalgo/T5-LM-Large-text2sql-spider'); \
                AutoModelForSeq2SeqLM.from_pretrained('gaussalgo/T5-LM-Large-text2sql-spider')"


USER jovyan
RUN ipython profile create

COPY src/ipython_config.py /tmp/
RUN cat /tmp/ipython_config.py >> /home/jovyan/.ipython/profile_default/ipython_config.py

FROM builder as udf

USER jovyan

# docker build . -t asia-south1-docker.pkg.dev/analytics-378517/takshashila/jupyter:base-4.0 -f ./jupyter_v2.Dockerfile --platform linux/amd64

