FROM ubuntu:latest
  
LABEL maintainer="sujan.sharma202.com"

ENV TZ=Asia/Kathmandu
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -i 's/archive.ubuntu.com/np.archive.ubuntu.com/g' /etc/apt/sources.list
RUN sed -i 's/security.ubuntu.com/us.security.ubuntu.com/g' /etc/apt/sources.list

ARG RUNNER_VERSION="2.290.1"

RUN apt-get update -y && apt-get upgrade -y && useradd -m runner

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN cd /home/runner && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R runner ~runner && /home/runner/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

RUN apt install -y git curl unzip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN rm awscliv2.zip

USER runner

WORKDIR /

ENTRYPOINT ["./start.sh"]