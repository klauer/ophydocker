FROM debian:stretch

MAINTAINER klauer <https://github.com/klauer>

USER root

RUN apt-get -q update
RUN apt-get install -yq curl build-essential git tmux locales procps
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN useradd --create-home --shell /bin/bash -G sudo --uid 1000 travis

USER travis
WORKDIR /home/travis

SHELL ["/bin/bash", "--login", "-c"]

COPY env.sh env.sh

RUN git clone --single-branch --branch master https://github.com/klauer/epics-on-travis /home/travis/ci

RUN echo "source $HOME/env.sh" >> .bash_profile
RUN echo "EPICS_CA_ADDR_LIST=" >> "$CI_SCRIPTS/epics-config.sh"
RUN echo "EPICS_PVA_ADDR_LIST=" >> "$CI_SCRIPTS/epics-config.sh"
RUN echo "EPICS_PVA_INTF_LIST=" >> "$CI_SCRIPTS/epics-config.sh"
RUN echo "EPICS_CAS_INTF_LIST=" >> "$CI_SCRIPTS/epics-config.sh"
RUN echo "EPICS_CA_AUTO_ADDR_LIST=YES" >> "$CI_SCRIPTS/epics-config.sh"

RUN env

RUN bash ${CI_TOP}/install-from-release.sh ${EPICS_ON_TRAVIS_URL}
RUN cp -f "${AREA_DETECTOR_PATH}/ADCore/iocBoot/EXAMPLE_commonPlugins.cmd" "${AREA_DETECTOR_PATH}/ADCore/iocBoot/commonPlugins.cmd"

EXPOSE 5064-5068

COPY run-epics-iocs-on-tmux.sh run-epics-iocs-on-tmux.sh
# CMD ["/bin/bash", "--login", "/home/travis/run-epics-iocs-on-tmux.sh"]
CMD ["/bin/bash", "--login", "-c", "export EPICS_CA_SERVER_PORT=5067; . /home/travis/ci/ci-scripts/run-motorsim-ioc.sh"]
