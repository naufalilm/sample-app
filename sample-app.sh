#!/bin/bash
set -e

rm -rf tempdir
docker rm -f samplerunning 2>/dev/null || true

mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile <<EOF
FROM python:3.10-slim
RUN pip install --no-cache-dir --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python", "/home/myapp/sample_app.py"]
EOF

cd tempdir
docker build --no-cache -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a