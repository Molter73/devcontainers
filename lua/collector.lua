local name = 'collector-builder'

local M = {}

M.setup = function(opts)
    local repo_path = opts.repo_path or os.exit(1)
    return {
        name = name,
        image = 'quay.io/mmoltras/devcontainers:collector',
        workingDir = repo_path,
        command = { '/bin/bash' },
        env = {
            { name = 'CMAKE_EXPORT_COMPILE_COMMANDS', value = 'ON' },
            { name = 'COLLECTOR_HOST_ROOT',           value = '/host' },
        },
        volumeMounts = opts.volumes or {},
        ports = {
            { containerPort = 8181, hostIP = '0.0.0.0', hostPort = 8181 },
        },
        stdin = true,
        tty = true,
    }
end

M.volume_claim = function()
    return {
        apiVersion = 'v1',
        kind = 'PersistentVolumeClaim',
        metadata = { name = 'collector-ccache', },
        spec = {
            accessModes = { 'ReadWriteOnce' },
            resources = { requests = { storage = '5Gi' } },
        },
    }
end

return M
