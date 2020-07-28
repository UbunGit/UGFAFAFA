import request from '@/utils/request'

export function list() {
    return request({
        method: 'get',
        url: '/tactics/list',
    });
}

export function detailed(id) {
    return request({
        method: 'get',
        url: '/tactics/detailed',
        params: {"id":id},
    });
}
