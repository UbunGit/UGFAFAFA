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
export function update(data) {
    if(data.id){
        return request({
            method: 'post',
            url: '/tactics/update',
            data: data,
        });
    }else{
     
        return request({
            method: 'post',
            url: '/tactics/add',
            data: data,
        });
    }
    
}
export function exit(params) {
    return request({
        method: 'get',
        url: '/tactics/exit',
        params: params,
    });
}

export function inputlist(id) {
    return request({
        method: 'get',
        url: '/tacticsinput/list',
        params: {"tacticsId":id},
    });
}

export function inputdetailed(id) {

    return request({
        method: 'get',
        url: '/tacticsinput/detailed',
        params: {"id":id},
    });
}

export function inputdelete(id) {

    return request({
        method: 'post',
        url: '/tacticsinput/delete',
        data: {"id":id},
    });
}

export function inputupdate(data) {
    if(data.id){
      
        return request({
            method: 'post',
            url: '/tacticsinput/update',
            data: data,
        });
    }else{
     
        return request({
            method: 'post',
            url: '/tacticsinput/add',
            data: data,
        });
    }
    
}
