function traceInventory(pbId, storeId){
	
	if (pbId == undefined ||  pbId =="" ){
		return ;
	} else {
		if (storeId == undefined || storeId == "")
			storeId = $("#storeId").val();

		if (storeId == undefined)
			return;
		else {
			var param = "formBean.storeId="+ storeId +"&formBean.pbId="+pbId;
			$.modalDialog({
				title : " 货品库存跟踪",
				width : 440,
				height : 220,
				modal : false,
				draggable:true,
				href : 'headqInventoryFlowJSPAction!openInvenTracePage?' + param,
			});
			}
	}
}