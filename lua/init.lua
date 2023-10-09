local collector_repo = os.getenv('GOPATH') .. '/src/github.com/stackrox/collector'
local falco_repo = os.getenv('GOPATH') .. '/src/github.com/falcosecurity/libs'

local volumes = {
    { name = 'proc-fs',        hostPath = { path = '/proc', } },
    { name = 'sys-fs',         hostPath = { path = '/sys', } },
    { name = 'etc-fs',         hostPath = { path = '/etc', } },
    { name = 'dev-fs',         hostPath = { path = '/dev', } },
    { name = 'usr-lib-fs',     hostPath = { path = '/usr/lib', } },
    { name = 'usr-src-fs',     hostPath = { path = '/usr/src', } },
    { name = 'modules-fs',     hostPath = { path = '/lib/modules', } },
    { name = 'docker-sock',    hostPath = { path = '/var/run/docker.sock', } },
    { name = 'collector-repo', hostPath = { path = collector_repo, } },
    { name = 'falco-repo',     hostPath = { path = falco_repo, } },
}

local collector_opts = {
    repo_path = collector_repo,
    volumes = {
        { mountPath = '/host/proc',    name = 'proc-fs',        readOnly = true, },
        { mountPath = '/host/sys',     name = 'sys-fs',         readOnly = true, },
        { mountPath = '/host/etc',     name = 'etc-fs',         readOnly = true, },
        { mountPath = '/host/usr/lib', name = 'usr-lib-fs',     readOnly = true, },
        { mountPath = collector_repo,  name = 'collector-repo', },
    },
}

local falco_opts = {
    repo_path = falco_repo,
    volumes = {
        { name = 'usr-src-fs',    mountPath = '/usr/src', },
        { name = 'modules-fs',    mountPath = '/lib/modules', },
        { name = 'docker-sock',   mountPath = '/var/run/docker.sock', },
        { name = 'dev-fs',        mountPath = '/host/dev',            readOnly = true, },
        { name = 'proc-fs',       mountPath = '/host/proc',           readOnly = true, },
        { name = 'sys-fs',        mountPath = '/host/sys',            readOnly = true, },
        { name = 'etc-fs',        mountPath = '/host/etc',            readOnly = true, },
        { name = 'usr-lib-fs',    mountPath = '/host/usr/lib',        readOnly = true, },
        { mountPath = falco_repo, name = 'falco-repo', },
    }
}


local metadata = {
    name = 'devcontainers',
    namespace = 'devcontainers',
    labels = {
        app = 'devcontainers',
    }
}

local collector = require('collector').setup(collector_opts)
local falco = require('falco').setup(falco_opts)

local spec = {
    containers = {
        collector,
        falco,
    },
    volumes = volumes,
}

return {
    apiVersion = 'v1',
    kind = 'Pod',
    metadata = metadata,
    spec = spec,
}
