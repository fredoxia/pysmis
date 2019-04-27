var PAZU_Config = { 
        prot:"http",              
        server: 'localhost',   
        port: 6894,            
        license:'8F34B771723DCC171F931EA900F9967E'              
    }
function pageSetup(){
	PAZU.TPrinter.paperName= "dayin";
	PAZU.TPrinter.marginTop= 0;                  //属性 上边距   数据类型：数字   单位：毫米 
	PAZU.TPrinter.marginBottom= 3;
	PAZU.TPrinter.marginLeft= 0;                 //属性 左边距   数据类型：数字   单位：毫米 
	PAZU.TPrinter.marginRight= 0;                //属性 右边距   数据类型：数字   单位：毫米 

}

function printContent(io){
	pageSetup();
	var space = "&nbsp;&nbsp;&nbsp;";
	var s = "<font size='5pt'>成都朴与素</font><br/>";
		s += "单据种类 : " + io.typeS + "<br/>";
		s += "单据号 : " + io.id + space + "<br/>供应商: " + io.supplier + "<br/>"; 
        s += "过账日期  : " + io.lastUpdateTime + "<br/>";
    	
    	s += "上欠 : " + io.preAcctAmt + space + "下欠  : " + io.postAcctAmt + "<br/>";

		s += "-----------------单据明细 ---------------<br/>";
	var products = io.products;

	var j =1;
	var k = 1; //每页多少行了
 	for (var i = 1; i <= products.length; i++){
	  	var product = products[i-1];
	  	s += i + space + product.productCode + product.color + space +product.quantity + space + product.recCost + space + product.totalRecCost + "<br/>";

  	}
 	
		s += "<b>总数 : " + io.totalQuantity + space +  "总金额 : " + io.totalRecCost + "</b><br/>";

  		PAZU.print("<br/>" + s);
}

