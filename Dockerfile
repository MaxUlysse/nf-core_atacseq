FROM nfcore/base:1.9
LABEL authors="Harshil Patel" \
      description="Docker image containing all software requirements for the nf-core/atacseq pipeline"

# Install the conda environment
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/nf-core-atacseq-1.2.2/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name nf-core-atacseq-1.2.2 > nf-core-atacseq-1.2.2.yml

# Instruct R processes to use these empty files instead of clashing with a local version
RUN touch .Rprofile
RUN touch .Renviron
