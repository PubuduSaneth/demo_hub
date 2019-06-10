FROM r-base
COPY . /usr/local/src/
WORKDIR /usr/local/src/
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install libcurl4-openssl-dev libssl-dev
RUN apt-get -y install apt-utils
RUN apt-get -y install libxml2-dev
RUN apt-get -y install pandoc
RUN R -e "install.packages('devtools')"
RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) {install.packages('BiocManager')}"
RUN R -e "BiocManager::install()"
RUN Rscript -e "BiocManager::install('HMMcopy'); BiocManager::install('GenomeInfoDb'); "