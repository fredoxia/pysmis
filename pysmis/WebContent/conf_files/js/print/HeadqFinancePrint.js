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
		s += "单据种类 : " + io.type + "<br/>";
        s += "单据号 : " + io.id + space + "<br/>客户: " + io.cust  + "<br/>地区: " + io.area + "<br/>"; 
        s += "单据日期  : " + io.createDate + "<br/>";
 
    	if (io.comment != "")
    	   s += "备注 : " + io.comment + "<br/>";
    	
    	if (io.invoiceDiscount != 0)
    	   s += "折扣 : " + io.invoiceDiscount + "<br/>";
    	
    	s += "上欠 : " + io.preAcctAmt + space + "下欠  : " + io.postAcctAmt + "<br/>";

		s += "-----------------单据明细 ---------------<br/>";
	var items = io.items;

	var j =1;
	var k = 1; //每页多少行了
 	for (var i = 1; i <= items.length; i++){
	  	var item = items[i-1];
	  	
	  	if (item.total == 0)
	  		continue;
	  	
	  	s += item.financeCategory + space +item.total + "<br/>";
	  	
  	}
 	
		s += "<b>总金额 : " + io.invoiceTotal + "</b><br/>";
	  	s +=  "<br/><br/>展厅电话 : 028-65775588"+ "<br/>"; 
	  	s +=  "加盟热线 : 18030617949/13568884488"+ "<br/>";
	  	s +=  "展厅地址  : 大成市场2期3楼52号";

  		PAZU.print("<br/>" + s);
}
