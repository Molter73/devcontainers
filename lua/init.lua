local collector_repo = os.getenv('GOPATH') .. '/src/github.com/stackrox/collector'
local falco_libs_repo = os.getenv('GOPATH') .. '/src/github.com/falcosecurity/libs'
local falco_testing_repo = os.getenv('GOPATH') .. '/src/github.com/falcosecurity/testing'
local falco_repo = os.getenv('GOPATH') .. '/src/github.com/falcosecurity/falco'

local collector = require('collector')
local falco = require('falco')

local read_id = function(arg)
    local cmd = 'id ' .. arg
    local p = io.popen(cmd, 'r')
    assert(p ~= nil, 'failed to run "' .. cmd .. '"')
    local out = p:read('*n')
    p:close()
    return out
end

local user = read_id('-u')
local group = read_id('-g')

local collector_claim = collector.volume_claim()
local falco_claim = falco.volume_claim()
local volumes = {
    { name = 'proc-fs',            hostPath = { path = '/proc', } },
    { name = 'sys-fs',             hostPath = { path = '/sys', } },
    { name = 'etc-fs',             hostPath = { path = '/etc', } },
    { name = 'dev-fs',             hostPath = { path = '/dev', } },
    { name = 'usr-lib-fs',         hostPath = { path = '/usr/lib', } },
    { name = 'usr-src-fs',         hostPath = { path = '/usr/src', } },
    { name = 'modules-fs',         hostPath = { path = '/lib/modules', } },
    { name = 'docker-sock',        hostPath = { path = '/var/run/docker.sock', } },
    { name = 'collector-repo',     hostPath = { path = collector_repo, } },
    { name = 'falco-libs-repo',    hostPath = { path = falco_libs_repo, } },
    { name = 'falco-testing-repo', hostPath = { path = falco_testing_repo, } },
    { name = 'falco-repo',         hostPath = { path = falco_repo, } },
    { name = 'collector-ccache',   persistentVolumeClaim = { claimName = collector_claim.metadata.name } },
    { name = 'falco-ccache',       persistentVolumeClaim = { claimName = falco_claim.metadata.name, } },
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
    user = user,
    group = group,
}

local falco_opts = {
    repo_path = falco_repo,
    volumes = {
        { mountPath = '/host/dev',            name = 'dev-fs',             readOnly = true, },
        { mountPath = '/host/proc',           name = 'proc-fs',            readOnly = true, },
        { mountPath = '/host/sys',            name = 'sys-fs',             readOnly = true, },
        { mountPath = '/host/etc',            name = 'etc-fs',             readOnly = true, },
        { mountPath = '/host/usr/lib',        name = 'usr-lib-fs',         readOnly = true, },
        { mountPath = '/usr/src',             name = 'usr-src-fs', },
        { mountPath = '/lib/modules',         name = 'modules-fs', },
        { mountPath = '/var/run/docker.sock', name = 'docker-sock', },
        { mountPath = '/root/.cache/ccache',  name = 'falco-ccache', },
        { mountPath = falco_libs_repo,        name = 'falco-libs-repo', },
        { mountPath = falco_testing_repo,     name = 'falco-testing-repo', },
        { mountPath = falco_repo,             name = 'falco-repo', },
    },
    user = user,
    group = group,
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
