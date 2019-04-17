var index = 0;
var calculateRowNum = 5;
var formSubmit = false;


function BSkeyDown(e){

	 var ieKey = event.keyCode;

	 if (ieKey==13){
	   if (event.srcElement.id == "clientName"){
		   searchCustomer(); 
		   event.returnValue=false;
	   } else if (event.srcElement.id.substring(0,7)=="barcode"){
		   var index_trigger = event.srcElement.id.substring(7);

	       var barcodeInput =$("#barcode" +index_trigger);
	       barcodeInput.focus();
	       event.returnValue=false;
	
	       retrieveProductByBarcode(index_trigger, "",barcodeInput.val(),0);

	   } else if (event.srcElement.id.substring(0,11)=="productCode"){
		   var index_trigger = event.srcElement.id.substring(11);
		   event.returnValue=false;
		   searchProductsProductCode(index_trigger);
 	   } else if (event.srcElement.id.substring(0,8)=="quantity"){
 		   $("#barcode"+index).focus();
	   } else
		   event.returnValue=false; 
	 }  else if (ieKey==8){
		    if((event.srcElement.tagName.toLowerCase() == "input" && event.srcElement.readOnly != true) || event.srcElement.tagName.toLowerCase() == "textarea"){
		        event.returnValue = true; 
		    } else
		    	event.returnValue = false;
	 } 
} 


document.onkeydown = BSkeyDown; 


function recordSubmit(){
	formSubmit = true;
}

/**
 * user input the product code and press enter
 */
function searchProductsProductCode(index_trigger){

	var productCode = $("#productCode" +index_trigger).val();

	if (validateProductCodeInput(productCode)){
	    var params= "formBean.productBarcode.product.productCode=" + productCode + "&formBean.indexPage=" + index_trigger+ "&formBean.fromSrc=1" ; 
	    
	    var url = encodeURI(encodeURI("productJSPAction!scanByProductCodeHeadq?" +params));
		
	    window.open(url,'新窗口','height=570, width=630, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');    
	}
}

/**
 * to validate the product code input
 */
function validateProductCodeInput(productCode){
	if (productCode.length <= 1){
		$.messager.alert('错误', '输入的货号太短', 'error');
       return false;
	}
	return true;
}

/**
 * just override the function
 */
function validateRowInputFromChild(currentBarcode){
	return true;
}

function retrieveProductByBarcode(index_trigger, suffix ,currentBarcode, fromSrc){
	var client_id = $("#clientID").val();
	
	var orderType = $("#orderType").val();
	
    var params= "formBean.productBarcode.barcode=" + currentBarcode + "&formBean.client_id=" + client_id + "&formBean.indexPage=" + index_trigger +"&formBean.orderType=" + orderType+"&formBean.fromSrc=" + fromSrc ; 

    $.post(baseurl +"/action/productJSONAction!search",params, backProcess,"json");

	//if the user just changed the original barcode information
	//then no need to add the index by one
    //alert(index_trigger + "," + index + "," + suffix + "," + currentBarcode);
    //0: from the barcode
    //1: from the product code
	if (index_trigger == index){
	    addNewRow();
	}

}

function backProcess(data){
	var fullOrSingle = $("#fullOrSingle").val();

	
	var barcodes = data.barcodes;
	var preIndex = data.index;
	var orderType = data.orderType;
	var where = data.where;
	
	var barcodeInput =  $("#barcode" +preIndex); 
	var productIdInput =  $("#productId" +preIndex);  
   	var unitInput =  $("#unit" +preIndex);  
	var brandInput =  $("#brand" +preIndex);   
	var productCodeInput = $("#productCode"+preIndex); 
	var quantityInput =  $("#quantity"+preIndex); 

	var wholeSalePriceInput = $("#wholeSalePrice"+preIndex); 
	var discountInput = $("#discount"+preIndex); 
	//var recCostInput = $("#recCost"+preIndex); 
	var numPerHandInput = $("#numPerHand" + preIndex);
	var boughtBeforeInput = $("#boughtBefore" + preIndex);
	var takeBeforeDiv = $("#takeBefore" + preIndex);
	var inventoryDiv = $("#inventory" + preIndex);
	var yearInput = $("#year" + preIndex);
	var quarterInput = $("#quarter" + preIndex);
	var colorInput = $("#color" + preIndex);
	var totalWholePriceRow = $("#totalWholeSalePrice" + preIndex);
	
	if (where == 1)
		quantityInput.focus();
	
    if (barcodes.length != 0){
   	
    	barcodeInput.val(barcodes[0].barcode);
    	productIdInput.val(barcodes[0].id);
		unitInput.val(barcodes[0].product.unit);
		brandInput.val(barcodes[0].product.brand.brand_Name);
		productCodeInput.val(barcodes[0].product.productCode);
		if (fullOrSingle == 0)
		   quantityInput.val(barcodes[0].product.numPerHand);
		else 
			quantityInput.val(1);
		yearInput.val( barcodes[0].product.year.year);
		quarterInput.val( barcodes[0].product.quarter.quarter_Name);
		var color = barcodes[0].color;
		var colorName = "";
		if (color != null)
    		colorName = color.name;
		
		colorInput.val( colorName);    
        
        var wholeSalePrice = 0;
        var lastInputPrice = barcodes[0].product.lastInputPrice;
        var lastChoosePrice = barcodes[0].product.lastChoosePrice;
        
        var wholeSalePrice1 = barcodes[0].product.wholeSalePrice;
        var wholeSalePrice2 = barcodes[0].product.wholeSalePrice2;
        var wholeSalePrice3 = barcodes[0].product.wholeSalePrice3;
        var salesPriceFactory = barcodes[0].product.salesPriceFactory;
        var discount =  barcodes[0].product.discount;
        var wholeSalePrice4 = (salesPriceFactory * discount).toFixed(2);
        var choosePrice = 0;
        
        //to set the whole price with the recent one
        var select1 = "";
        var select2 = "";
        var select3 = "";
        var select4 = "";
//alert(lastInputPrice+","+lastChoosePrice+","+discount);
        if (lastInputPrice >0 && lastChoosePrice>0  && discount>0){
        	wholeSalePrice = lastInputPrice;
        	choosePrice = lastChoosePrice;
        } else if (orderType == 0){ 
        	if (wholeSalePrice3 > 0){
        		wholeSalePrice = wholeSalePrice3;
        		choosePrice = wholeSalePrice3;
        		discount =1;
        	} else if (wholeSalePrice2 > 0){
        		wholeSalePrice = wholeSalePrice2;
        		choosePrice = wholeSalePrice2;
        		discount =1;      	
        	} else if (wholeSalePrice1 > 0){
        		wholeSalePrice = wholeSalePrice1;
        		choosePrice = wholeSalePrice1;
        		discount =1;       	
        	} else if (wholeSalePrice4 > 0){
        		wholeSalePrice = wholeSalePrice4;
        		choosePrice = salesPriceFactory;
        	} 
        }

        switch (choosePrice){
        	case wholeSalePrice1:
        		select1 = "selected";
        		break;
        	case wholeSalePrice2:
        		select2 = "selected";
        		break;
        	case wholeSalePrice3:
            	select3 = "selected";
            	break;
        	case salesPriceFactory:
            	select4 = "selected";
            	break;
            default: ;
        }

        wholeSalePriceInput.val(wholeSalePrice);
        discountInput.val(discount);
        
        totalWholePriceRow.val((wholeSalePrice * quantityInput.val()).toFixed(2));
        
        //set the price select drop down
        $("#priceSlect" +preIndex).empty();
        $("#priceSlect" +preIndex).append("<option value='"+wholeSalePrice1+"'"+select1+">预设价1 "+wholeSalePrice1+"</option>"); 
        $("#priceSlect" +preIndex).append("<option value='"+wholeSalePrice2+"'"+select2+">预设价2 "+wholeSalePrice2+"</option>"); 
        $("#priceSlect" +preIndex).append("<option value='"+wholeSalePrice3+"'"+select3+">预设价3 "+wholeSalePrice3+"</option>"); 
        $("#priceSlect" +preIndex).append("<option value='"+salesPriceFactory+"'"+select4+">零售价 "+salesPriceFactory+"</option>"); 
        
/*        var recCost = barcodes[0].product.recCost;
        if (recCost == "")
        	recCostInput.val("");
        else
        	recCostInput.val(recCost);*/
        
		numPerHandInput.val(barcodes[0].product.numPerHand);
		
		if (barcodes[0].boughtBefore != 0){
			boughtBeforeInput.val(barcodes[0].boughtBefore);
			takeBeforeDiv.html("配" + barcodes[0].boughtBefore);
			takeBeforeDiv.show();
         }else
			takeBeforeDiv.hide();
		
		inventoryDiv.html(" 库存" + barcodes[0].inventoryLevel);
		inventoryDiv.show();

		$("#row"+preIndex).css('background-color', '');		
    } else {
    	var errorRow = $("#row"+preIndex);
    	if (errorRow.length != 0){

    	  errorRow.css('background-color', '#EE8553');
    	  document.getElementById("bgs").src = baseurl+"/conf_files/web-image/error.mp3";
    	}
    	barcodeInput.val("");
    	productIdInput.val("");
		unitInput.val("");
		brandInput.val("");
		productCodeInput.val("");
		quantityInput.val("");
		yearInput.val("");
		quarterInput.val("");
		//recCostInput.val("");
		wholeSalePriceInput.val("");
		discountInput.val("");
		salePriceInput.val("");
		$("#priceSlect" +preIndex).empty();
    }

    var barcodeInput = $("#barcode"+preIndex);
    barcodeInput.attr("readonly",true);
    
    calculateTotal();
}


function calculateTotal(){
	 var totalQ = 0;
//	 var totalRetailPrice = 0;
//	 var totalRecCost = 0;
	 var totalWholePrice = 0;
	 
	 for (var i =0; i < index; i++){
		 var quantityInputs = $("#quantity" + i).val();

//		 var recCostInputs = $("#recCost" + i).val();
		 var wholeSalePriceInputs = $("#totalWholeSalePrice" + i).val();
		 
		 if (quantityInputs != undefined){
			 totalQ = totalQ + parseInt(quantityInputs);
		 } 

//		 if (quantityInputs != undefined && recCostInputs != undefined && recCostInputs !=""){
//			 totalRecCost = totalRecCost + parseInt(quantityInputs)*parseFloat(recCostInputs);
//		 } 
		 if (quantityInputs != undefined && wholeSalePriceInputs != undefined && wholeSalePriceInputs !=""){
			 totalWholePrice = totalWholePrice + parseFloat(wholeSalePriceInputs);
		 } 
	 }
	 
	 $("#totalQuantity").val(totalQ);
//	 $("#totalRetailPrice").val((totalRetailPrice).toFixed(2));
//	 $("#totalRecCost").val((totalRecCost).toFixed(2));
	 $("#totalWholePrice").val((totalWholePrice).toFixed(2));
	 
	 var orderType = $("#orderType").val();

	 //销售退货
	 if (orderType == 1){
			var floor = Math.floor(totalWholePrice);

			var discount = (floor - totalWholePrice).toFixed(2);
			$("#totalDiscount").numberbox("setValue",discount);
	//销售出库
	} else if (orderType == 0){
			var floor = Math.floor(totalWholePrice);

			var discount = (totalWholePrice - floor).toFixed(2);
			$("#totalDiscount").numberbox("setValue",discount);
	}
	 
	 calculateCasher();
}

function calculatePostAcct(){
	var casherInput = $("#casher");
	var casher = parseFloat(casherInput.numberbox("getValue"));
	
	var preAcctInput = $("#preAcct");
	var preAcct = parseFloat(preAcctInput.val());
	if (isNaN(preAcct))
		preAcct = 0;
	
	$("#postAcct").val((preAcct+casher).toFixed(2));
}

function calculateCasher(){
	var totalWhole = parseFloat($("#totalWholePrice").val());
	var discount = parseFloat($("#totalDiscount").val());
	var orderType = $("#orderType").val();
	var cash = parseFloat($("#cash").val());
	var card = parseFloat($("#card").val());
	var alipay = parseFloat($("#alipay").val());
	var wechat = parseFloat($("#wechat").val());
    
	if (isNaN(discount))
		discount = 0;
	if (isNaN(cash))
		cash = 0;
	if (isNaN(card))
		card = 0;
	if (isNaN(alipay))
		alipay = 0;
	if (isNaN(wechat))
		wechat = 0;
	
	var casherInput = $("#casher");
	 //销售退货
	 if (orderType == 1){
		 var result = totalWhole+discount+cash+card+alipay+wechat;

		 casherInput.numberbox("setValue",(result).toFixed(2));
	//销售出库
	} else if (orderType == 0){
		casherInput.numberbox("setValue",( totalWhole-discount-cash-card-alipay-wechat).toFixed(2));
	}
	 
	 calculatePostAcct();
}
/*
function calculateWholeTotal(){
	 var totalWholePrice = 0;
	 
	 for (var i =0; i < index; i++){
		 var quantityInputs = $("#quantity" + i).val();
		 var wholeSalePriceInputs = $("#wholeSalePrice" + i).val();

		 if (quantityInputs != undefined && wholeSalePriceInputs != undefined && wholeSalePriceInputs !=""){
			 totalWholePrice = totalWholePrice + parseInt(quantityInputs)*parseFloat(wholeSalePriceInputs);
		 } 
	 }
	 
	 $("#totalWholePrice").val((totalWholePrice).toFixed(2));
}*/

function deleteRow(rowID, delIndex){
	var brand = $("#brand" + delIndex).val();
	var productCode = $("#productCode" + delIndex).val();
	var msg = "你确定要删除第" + (delIndex + 1) + "行 : " + brand + " " + productCode;
	
	$("#row" + delIndex).css('background-color', '#99CC00');
	$.messager.confirm('删除货品确认', msg, function(r){
		if (r){
			$("#"+rowID).remove(); 
			
			calculateTotal(); 
		} else {
			$("#row" + delIndex).css('background-color', '');
		}
	});

}

function addNewRow(){
	$("#delIcon"+index).show();
	index = index +1;
    var str = "";
    str += "<tr height='22' id='row"+ index + "' class='excelTable'>";
    str += "<td align='center'>" + (index+1) +"</td>";
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].productBarcode.barcode' id='barcode"+index+"' size='10'/>" +
               "<input type='hidden' name='formBean.order.product_List["+index+"].productBarcode.id' id='productId"+index+"'/></td>";		 					 		
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].productBarcode.product.productCode'  id='productCode"+index+"'  size='8'/></td>";
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].productBarcode.color.name' readonly  id='color"+index+"'  size='2'/></td>";	
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].productBarcode.product.brand.brand_Name' readonly  id='brand"+index+"'  size='12'/></td>";			 					 		
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].productBarcode.product.year.year' readonly  id='year"+index+"'  size='2'/></td>";	
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].productBarcode.product.quarter.quarter_Name' readonly  id='quarter"+index+"'  size='2'/></td>";	
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].quantity' id='quantity"+index+"' value='0' size='2'  onchange='onQuantityChange("+index+");'  onfocus='this.select();'/>  <input type='hidden' name='formBean.order.product_List["+index+"].productBarcode.product.numPerHand' id='numPerHand"+index+"' size='5' value='0' /></td>";
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].productBarcode.product.unit' readonly  id='unit"+index+"'  size='3'/></td>";			 					 		
    str += "<td><select id='priceSlect"+index+"' name='formBean.order.product_List["+index+"].salePriceSelected' onchange='onWholeSalePriceChange(3,"+index+");'></select></td>";
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].discount' id='discount"+index+"' onchange='onWholeSalePriceChange(1,"+index+");' onfocus='this.select();' size='3'/></td>";
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].wholeSalePrice'  onchange='onWholeSalePriceChange(2,"+index+");' id='wholeSalePrice"+index+"'  size='8'   onfocus='this.select();'/></td>";
//    str += "<td><input type='text' name='formBean.order.product_List["+index+"].recCost' readonly id='recCost"+index+"'  size='8'/></td>";
    str += "<td><input type='text' name='formBean.order.product_List["+index+"].totalWholeSalePrice' id='totalWholeSalePrice"+index+"'  size='8'/></td>" ;
    str += "<td><div id='delIcon"+index+"' style='display:none'> <img src='"+baseurl+"/conf_files/web-image/delete.png' border='0' onclick='deleteRow(\"row"+index +"\","+index+")' style='cursor:pointer;'/></div></td>";			 		
    str += "<td><div id='inventory"+index+"' style='display:inline;color:blue'></div>&nbsp;<div id='takeBefore"+index+"' style='display:inline;color:red'></div><input type='hidden' name='formBean.order.product_List["+index+"].productBarcode.boughtBefore' id='boughtBefore"+index+"' size='14' value='0'/></td>";
    str += "</tr>";

    $("#inventoryTable").append(str);
    
    $("#barcode"+index).focus();

    $("#row"+ index).bind('keyup',onkeyup);
    
	$("#row"+ index).mouseover(function(){      
		$(this).addClass("over");}).mouseout(function(){    
		$(this).removeClass("over");}); 
}

function validateForm(){
	var error ="";
	for (var i =0; i < index; i++)
		$("#row" + i).css('background-color', '');
	
	var error = "";
	if ($("#clientName").val() == "" || $("#clientID").val() == 0){
		error += "客户名字 - 必须填!<br\>";
		$("#clientName").focus();
	}

	if ($("#keeper_id").val() == 0){
		error += "单据输入人员 - 必须选!<br\>";
		$("#keeper_id").focus();
	}
	if ($("#scanner_id").val() == 0){
		error += "扫描人员 - 必须选!<br\>";
		$("#scanner_id").focus();
	}
	if ($("#counter_id").val() == 0){
		error += "点数人员 - 必须选!<br\>";
		$("#counter_id").focus();
	}

	if ($("#totalQuantity").val() <= 0){
		error += "必须录入数据后才能输入<br\>";
	}

	var hasChar = false;
	var hasChar_w = false;
	var invalid_d = false;
	var invalid_barcode = false;
	for (var i =0; i < index; i++){

		var q = $("#quantity" + i).val();
		var w = $("#wholeSalePrice" + i).val();
		var d = $("#discount" + i).val();
		var pbId = $("#productId" + i).val();

		if (q != undefined){
			if (isNaN(q) || q<=0){
				$("#row" + i).css('background-color', '#EE8553');
				hasChar = true;
			}
		}
		if (w != undefined){
			if (isNaN(w) || w<=0 || w=='Infinity'){
				$("#row" + i).css('background-color', '#EE8553');
				hasChar_w = true;
			}
		}
		if (d != undefined){
			if (isNaN(d) || d<=0 || d=='Infinity'){
				$("#row" + i).css('background-color', '#EE8553');
				invalid_d = true;
			}
		}
		if (pbId != undefined){
			if (isEmpty(pbId) || pbId == 0){
				$("#row" + i).css('background-color', '#EE8553');
				invalid_barcode = true;
			}
		}
	}
	
	if (hasChar)
		error += "数量 - 必须为大于0数字!<br\>";
	if (hasChar_w)
		error += "批发价格 - 必须为大于0数字!<br\>";	
	if (invalid_d)
		error += "折扣 - 必须为大于0的数字!<br\>";	
	if (invalid_barcode)
		error += "条码错误 - 货品条码无法找到,请删除再从新扫描!<br\>";	
	
	return error;

}

function changeTotalWholePriceRow(triggerIndex){

	var discountInputs = $("#discount" + triggerIndex).val();
	var quantityInputs = $("#quantity" + triggerIndex).val();
	var wholeSalePriceInputs = $("#wholeSalePrice" + triggerIndex).val();
	var totalWholePrice = parseInt(quantityInputs)*parseFloat(wholeSalePriceInputs); 
	$("#totalWholeSalePrice" + triggerIndex).val((totalWholePrice).toFixed(2));
}
/**
 * 数量改变
 */
function onQuantityChange(triggerIndex){
	changeTotalWholePriceRow(triggerIndex);

	calculateTotal();
}
/**
 * on the discount or whole sale price change, need re-calculate the total of the whole price
 * triggerSource 1 = discount
 *               2 = whole sale price
 *               3 = sale price drop down
 */
function onWholeSalePriceChange(triggerSource,triggerIndex){
	 
	 var consistent = true;
     var wholePrice = 0;
	 var totalWholePrice = 0;
	 var discountInput = $("#discount" + triggerIndex);
	 var salePriceInput = $("#priceSlect" + triggerIndex);
	 var wholeSalePriceInput = $("#wholeSalePrice" + triggerIndex);
	 var salePrice = parseFloat(salePriceInput.val());
	 
	 //1. on change on the entity and at the sametime change the corresponding elements in the web page
	 if (triggerSource == 1){
		 var discount = parseFloat(discountInput.val());
		 wholePrice = salePrice * discount;
		 wholeSalePriceInput.val((wholePrice).toFixed(2));
	 } else if (triggerSource == 2){
		 wholePrice = parseFloat(wholeSalePriceInput.val());
		 var discount = wholePrice / salePrice;
		 discountInput.val((discount).toFixed(2));
	 } else if (triggerSource == 3){
		 var discount = parseFloat(discountInput.val());
		 wholePrice = salePrice * discount;
		 wholeSalePriceInput.val((wholePrice).toFixed(2));
	 }
	 
	 changeTotalWholePriceRow(triggerIndex);
		
	 
	 //2. calclate the total value and checkt the price consistent
	 for (var i =0; i < index; i++){
			 //calate the total value
			 var wholeSalePriceInputs = $("#wholeSalePrice" + i).val();
			 
			 if ( wholeSalePriceInputs != undefined && wholeSalePriceInputs !=""){
				 //check the value consistent
				 var productIdChange = $("#productId" + triggerIndex).val();
				 var productIdLoop = $("#productId" + i).val();
				 if (i != triggerIndex && productIdChange == productIdLoop){
					 if (wholePrice != wholeSalePriceInputs)
						 consistent = false;
				 }
			 } 
	}
	
	 calculateTotal();
		 
	if (!consistent){
		var productCode = $("#productCode" + triggerIndex).val();
		$.messager.alert('失败', productCode + ' 该商品出现批发价不一致情况，请检查', 'error');

	}

}

function importFile(){
	 window.open("action/inventoryOrder!preUploadFile",'新窗口','height=200, width=300, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no');    
}

function retrieveProductByExcel(products){

    if (products.length != 0){
    	for (var i = 0 ; i < products.length; i++){
    		
    	 	var barcodeInput =  $("#barcode" +index); 
        	var productIdInput =  $("#productId" +index);  
           	var unitInput =  $("#unit" +index);  
        	var brandInput =  $("#brand" +index);   
        	var productCodeInput = $("#productCode"+index); 
        	var quantityInput =  $("#quantity"+index); 

        	var wholeSalePriceInput = $("#wholeSalePrice"+index); 
        	var discountInput = $("#discount"+index); 
//        	var recCostInput = $("#recCost"+index); 
        	var numPerHandInput = $("#numPerHand" + index);
        	var yearInput = $("#year" + index);
        	var quarterInput = $("#quarter" + index);
        	var colorInput = $("#color" + index);
        	
        	barcodeInput.val(products[i].productBarcode.barcode);
        	productIdInput.val(products[i].productBarcode.id);
    		unitInput.val(products[i].productBarcode.product.unit);
    		brandInput.val(products[i].productBarcode.product.brand.brand_Name);
    		productCodeInput.val(products[i].productBarcode.product.productCode);
    		quantityInput.val(products[i].quantity);
    		yearInput.val( products[i].productBarcode.product.year.year);
    		quarterInput.val( products[i].productBarcode.product.quarter.quarter_Name);
    		var color = products[i].productBarcode.color;
    		if (color != null)
    		    colorInput.val( color.name);


            var wholeSalePrice = products[i].wholeSalePrice;
            var priceSelected = products[i].salePriceSelected;
            var wholeSalePrice1 = products[i].productBarcode.product.wholeSalePrice;
            var wholeSalePrice2 = products[i].productBarcode.product.wholeSalePrice2;
            var wholeSalePrice3 = products[i].productBarcode.product.wholeSalePrice3;
            var salesPriceFactory = products[i].productBarcode.product.salesPriceFactory;
            var discount =  products[i].discount;
            
            //to set the whole price with the recent one
            var select1 = "";
            var select2 = "";
            var select3 = "";
            var select4 = "";
            
            switch (priceSelected){
            	case wholeSalePrice1:
            		select1 = "selected";
            		break;
            	case wholeSalePrice2:
            		select2 = "selected";
            		break;
            	case wholeSalePrice3:
                	select3 = "selected";
                	break;
            	case salesPriceFactory:
                	select4 = "selected";
                	break;
                default: alert("no price");
            }

            wholeSalePriceInput.val((wholeSalePrice).toFixed(2));
            discountInput.val((discount).toFixed(2));

            
            //set the price select drop down
            $("#priceSlect" +index).empty();
            $("#priceSlect" +index).append("<option value='"+wholeSalePrice1+"'"+select1+">预设价1 "+wholeSalePrice1+"</option>"); 
            $("#priceSlect" +index).append("<option value='"+wholeSalePrice2+"'"+select2+">预设价2 "+wholeSalePrice2+"</option>"); 
            $("#priceSlect" +index).append("<option value='"+wholeSalePrice3+"'"+select3+">预设价3 "+wholeSalePrice3+"</option>"); 
            $("#priceSlect" +index).append("<option value='"+salesPriceFactory+"'"+select4+">零售价 "+salesPriceFactory+"</option>"); 
            
//            var recCost = products[i].productBarcode.product.recCost;
//            recCostInput.val((recCost).toFixed(2));
            
    		numPerHandInput.val(products[i].numPerHand);

    	    barcodeInput.attr("readonly",true);
    	    
	        addNewRow();
    	}
    	
    	calculateTotal();
    }
	
    alert("完成导入，请检查");
}


function deleteOrder(){
	$.modalDialog({
		title : '授权删除单据',
		width : 330,
		height : 180,
		modal : true,
		href : baseurl +'/jsp/headQ/inventory/ConfirmDelete.jsp',
		buttons : [ {
			text : '授权删除',
			handler : function() {
				confirmDelete(); 
			}
		} ]
		});
}