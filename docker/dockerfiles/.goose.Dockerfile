ARG image
FROM ${image} as base

ARG default_dir
ENV GOOSE_MIGRATION_DIR=${default_dir}

ARG repo
RUN go install ${repo}