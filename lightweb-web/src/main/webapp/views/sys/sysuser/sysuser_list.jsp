<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ include file="../../common/global.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查询列表</title>
<link rel="stylesheet" href="${rs}/js/plugins/table/docs/assets/bootstrap/css/bootstrap.min.css"/>
<link rel="stylesheet" href="${rs}/js/plugins/table/dist/bootstrap-table.min.css"/>
<script src="${rs}/js/plugins/table/docs/assets/bootstrap/js/bootstrap.min.js"></script>
<script src="${rs}/js/plugins/table/dist/bootstrap-table.min.js"></script>
<script src="${rs}/js/plugins/table/dist/locale/bootstrap-table-zh-CN.min.js"></script>
<script>
	//添加
	function toAdd(){
		window.location='${path}/sysUserController/toAdd.do';
	}
	//删除
	function toRemove(){
		var ids=getSelectedRowsIds('SysUserList');
		if(ids){
			top.showConfirmDiaglog('提示','删除数据不可恢复，确定要删除吗？',function(){  //关闭事件
				refleshData('SysUserList');
			},function(){  //确认事件
				 $.post('${path}/sysUserController/deleteById.do?ids='+ids,function(json){
					
				    if(json.success){
				    	top.showArtDiaglog('提示','删除成功',function(){  //关闭事件
				    		refleshData('SysUserList');
	 					},function(){   //确定事件
	 						top.closeDialog();
	 					});
				    }else{
				    	top.showArtDiaglog('提示','删除失败',function(){  //关闭事件
	 					},function(){   //确定事件
	 						top.closeDialog();
	 					});
				    }
				 });
			});
		}else{
			top.showArtDiaglog('提示','请选择一条数据进行操作',null,function(){
				top.closeDialog();
			});
		}
	}
	
	//编辑
    function toEdit(){
    	var selected=getSelectedRowsArr('SysUserList');
    	if(selected.length>0&&selected.length<2){
    		window.location='${path}/sysUserController/editById.do?id='+selected;
    	}else{
    		//提示信息
    		top.showArtDiaglog('提示','请选择一条数据进行操作',null,function(){
    			top.closeDialog();
			});
    	}
	}
	
    //查看
    function toInfo(){
    	var selected=getSelectedRowsArr('SysUserList');
    	if(selected.length>0&&selected.length<2){
    		window.location='${path}/sysUserController/findById.do?id='+selected;
    		
    	}else{
    		top.showArtDiaglog('提示','请选择一条数据进行操作',null,function(){
    			top.closeDialog();
			});
    	}
	}
	
	//设置查询参数
	function postQueryParams(params) {
		var queryParams = $("#searchForm").serializeObject();
		queryParams.limit=params.limit;
		queryParams.offset=params.offset;
		return queryParams;
	}
	//查询列表
    function queryList(){
    	$('#SysUserList').bootstrapTable('refresh');
    }
    
    function editById(id){
		window.location='${path}/sysUserController/editById.do?id='+id;
	}

	//根据id删除
	function deleteById(id){
		top.showConfirmDiaglog('提示','删除数据不可恢复，确定要删除吗？',function(){  //关闭事件
				refleshData('SysUserList');
			},function(){  //确认事件
				 $.post('${path}/sysUserController/deleteById.do?ids='+id,function(json){
				   
				   if(json.success){
					   top.showArtDiaglog('提示','删除成功',function(){  //关闭事件
						   refleshData('SysUserList');
	 					},function(){   //确定事件
	 						top.closeDialog();
	 					});
				   }else{
					   top.showArtDiaglog('提示','删除失败',function(){  //关闭事件
	 					},function(){   //确定事件
	 						top.closeDialog();
	 					});
				   }
			});
		});
	}

	//根据id查看
	function viewById(id){
			window.location='${path}/sysUserController/findById.do?id='+id;
	}
	
    //操作工具栏
    function operatorFormatter(value, row, index) {
    	var operator="";
	    	<shiro:hasPermission name="SysUser:edit">
	    		operator+='<button class="btn btn-warning btn-round btn-xs" onclick="editById(\''+row.id+'\');"><i class="glyphicon glyphicon-pencil"></i> 修改</button>&nbsp;&nbsp;';
		    </shiro:hasPermission>
		    <shiro:hasPermission name="SysUser:info">
				operator+='<button class="btn btn-success btn-round btn-xs" onclick="viewById(\''+row.id+'\')"><i class="glyphicon glyphicon-list-alt"></i>详情</button>&nbsp;&nbsp;';
	    	</shiro:hasPermission>
	    	<shiro:hasPermission name="SysUser:remove">
				operator+='<button class="btn btn-danger btn-round btn-xs" onclick="deleteById(\''+row.id+'\')"><i class="glyphicon glyphicon-trash"></i>删除</button>';
			</shiro:hasPermission>
		return operator;
	}
    
    //格式化状态
    function statusFormatter(value,row,index){
    	if(value=='1'){
    		return '<span class="label label-success label-lg">启用</span>';
    	}else if(value=='2'){
    		return '<span class="label label-danger arrowed">锁定</span>';
    	}else{
    		return "";
    	}
    }
    
    //格式化用户类型
    function userTypeFormatter(value,row,index){
    	if(value=='1'){
    		return '超级管理员';
    	}else if(value=='2'){
    		return '管理员';
    	}else if(value=='3'){
    		return '发布方';
    	}else if(value=='4'){
    		return '普通会员';
    	}else{
    		return '';
    	}
    }
    
    
    
    function setUser(){
    	var selected=getSelectedRowsArr('SysUserList');
    	if(selected.length>0&&selected.length<2){
    		var dialog = art.dialog.open("${path}/sysRoleController/toUserRoleTree.do?userId="+selected,{
    	  		  id:"selectResourceDialog",
    	  		  title:"选择角色",
    	  		  width :'300px',
    	  		  height:'380px',
    	  		  lock:true,
    	  		  init: function (){
    		  		$(this.iframe).attr("scrolling","no");//去掉滚动条
    		  	  },
    	  		  close:function(){
    	  			  
    	  		  }
    	  	});
    	}else{
    		//提示信息
    		top.showArtDiaglog('提示','请选择一条数据进行操作',null,function(){
    			top.closeDialog();
			});
    	}
    }
    
    function closeDialog(){
    	art.dialog.list["selectResourceDialog"].close();
    }
    
</script>
</head>
<body>
	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">系统管理</a></li>
    <li><a href="#">权限管理</a></li>
    <li><a href="#">用户管理列表</a></li>
    </ul>
    </div>
    
    <div class="rightinfo">
		<div>
    		<form id="searchForm" name="searchForm"  method="post">
    			<label>用户名：</label><input type="text" name="userName" class="txtSearch">&nbsp;
    			<label>用户类型：</label>
    			<select name="userType" id="userType" class="txtSearch">
						<option value="1">超级管理员</option>
						<option value="2">管理员</option>
						<option value="3" selected="selected">发布方</option>
						<option value="4">普通会员</option>
				</select>
    			<input type="button" class="btn btn-info btn-round" value="查询" onclick="queryList()">&nbsp;&nbsp;
    			<input type="button" class="btn btn-warning btn-round" value="重置" onclick="$('#searchForm')[0].reset();"> 
    		</form>
    	</div>
	    <div id="toolbar" class="btn-group">
	    	<shiro:hasPermission name="SysUser:add">
		    	<button class="btn btn-info btn-round" onclick="toAdd();">
					<i class="glyphicon glyphicon-plus"></i>添加
				</button>
		    </shiro:hasPermission>
	    	<shiro:hasPermission name="SysUser:edit">
	    		<button class="btn btn-warning btn-round" onclick="toEdit();">
					<i class="glyphicon glyphicon-pencil"></i> 修改
				</button>
	    	</shiro:hasPermission>
			<shiro:hasPermission name="SysUser:info">
				<button class="btn btn-success btn-round" onclick="toInfo()">
					<i class="glyphicon glyphicon-list-alt"></i>详情
				</button>
			</shiro:hasPermission>
			<shiro:hasPermission name="SysUser:remove">
				<button class="btn btn-danger btn-round" onclick="toRemove()">
					<i class="glyphicon glyphicon-trash"></i>删除
				</button>
			</shiro:hasPermission>
			<shiro:hasPermission name="SysUser:setRole">
				<button class="btn btn-info btn-round" onclick="setUser();">
					<i class="fa fa-users"></i> 分配角色
				</button>
			</shiro:hasPermission>
		</div>
    
    	<table id="SysUserList" data-toggle="table"
			data-url="${path}/sysUserController/list.do" data-pagination="true"
			data-side-pagination="server" data-cache="false" data-query-params="postQueryParams"
			data-page-list="[10, 15, 20, 30, 50,100]" data-method="post"
			data-show-refresh="true" data-show-toggle="true"
			data-show-columns="true" data-toolbar="#toolbar"
			data-click-to-select="true" data-single-select="false"
			data-striped="true" data-content-type="application/x-www-form-urlencoded"
			>
			<thead>
				<tr>
					<th data-field="" data-checkbox="true"></th>
					<th data-field="userName">用户名</th>
					<th data-field="account">账号</th>
					<th data-field="email">电子邮箱</th>
					<th data-field="mobilePhone">手机号码</th>
					<th data-field="regTime" data-formatter="dateFormatter" >添加时间</th>
					<th data-field="idNumber">身份证号</th>
					<th data-field="userType" data-formatter="userTypeFormatter">用户类型</th>
					<th data-field="lastLoginTime" data-formatter="dateFormatter" >上次登录时间</th>
					<th data-field="status" data-formatter="statusFormatter">状态</th>
					<th data-field="operator" data-formatter="operatorFormatter">操作</th>
				</tr>
			</thead>
		</table>
    </div>
</body>
</html>