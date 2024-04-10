local collector_repo = os.getenv('GOPATH') .. '/src/github.com/stackrox/collector'
local falco_repo = os.getenv('GOPATH') .. '/src/github.com/falcosecurity/libs'
local os_uni_repo = os.getenv('GOPATH') .. '/src/github.com/molter73/os-uni'
local user_name = os.getenv("USER")

local collector = require('collector')
local falco = require('falco')
local os_uni = require('os-uni')

local collector_claim = collector.volume_claim()
local falco_claim = falco.volume_claim()
local volumes = {
    { name = 'proc-fs',          hostPath = { path = '/proc', } },
    { name = 'sys-fs',           hostPath = { path = '/sys', } },
    { name = 'etc-fs',           hostPath = { path = '/etc', } },
    { name = 'dev-fs',           hostPath = { path = '/dev', } },
    { name = 'usr-lib-fs',       hostPath = { path = '/usr/lib', } },
    { name = 'usr-src-fs',       hostPath = { path = '/usr/src', } },
    { name = 'modules-fs',       hostPath = { path = '/lib/modules', } },
    { name = 'docker-sock',      hostPath = { path = '/var/run/docker.sock', } },
    { name = 'collector-repo',   hostPath = { path = collector_repo, } },
    { name = 'falco-repo',       hostPath = { path = falco_repo, } },
    { name = 'os-uni-repo',      hostPath = { path = os_uni_repo, } },
    { name = 'collector-ccache', persistentVolumeClaim = { claimName = collector_claim.metadata.name } },
    { name = 'falco-ccache',     persistentVolumeClaim = { claimName = falco_claim.metadata.name, } },
}

local collector_opts = {
    repo_path = collector_repo,
    volumes = {
        { mountPath = '/host/proc',          name = 'proc-fs',          readOnly = true, },
        { mountPath = '/host/sys',           name = 'sys-fs',           readOnly = true, },
        { mountPath = '/host/etc',           name = 'etc-fs',           readOnly = true, },
        { mountPath = '/host/usr/lib',       name = 'usr-lib-fs',       readOnly = true, },
        { mountPath = '/root/.cache/ccache', name = 'collector-ccache', },
        { mountPath = collector_repo,        name = 'collector-repo', },
    },
}

local falco_opts = {
    repo_path = falco_repo,
    volumes = {
        { mountPath = '/host/dev',            name = 'dev-fs',       readOnly = true, },
        { mountPath = '/host/proc',           name = 'proc-fs',      readOnly = true, },
        { mountPath = '/host/sys',            name = 'sys-fs',       readOnly = true, },
        { mountPath = '/host/etc',            name = 'etc-fs',       readOnly = true, },
        { mountPath = '/host/usr/lib',        name = 'usr-lib-fs',   readOnly = true, },
        { mountPath = '/usr/src',             name = 'usr-src-fs', },
        { mountPath = '/lib/modules',         name = 'modules-fs', },
        { mountPath = '/var/run/docker.sock', name = 'docker-sock', },
        { mountPath = '/root/.cache/ccache',  name = 'falco-ccache', },
        { mountPath = falco_repo,             name = 'falco-repo', },
    }
}

local os_uni_opts = {
    repo_path = os_uni_repo,
    volumes = {
        { mountPath = os_uni_repo, name = 'os-uni-repo', },
    },
}

local metadata = {
    name = 'devcontainers',
    namespace = 'devcontainers',
    labels = {
        app = 'devcontainers',
    }
}

local spec = {
    containers = {
        collector.setup(collector_opts),
        falco.setup(falco_opts),
        os_uni.setup(os_uni_opts),
    },
    volumes = volumes,
}

local pod = {
    apiVersion = 'v1',
    kind = 'Pod',
    metadata = metadata,
    spec = spec,
}

return {
    collector_claim,
    falco_claim,
    pod,
}
