<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- used by PreviewInventoryOrder.jsp -->
	<tr>	
	   <td colspan="7">
			<table cellpadding="0" cellspacing="0" style="width: 100%" border="0" id="org_table">
			    
			 	<tr class="PBAOuterTableTitale">
			 		<th>&nbsp;</th>
			 		<th align="right">客户名字&nbsp; :</th>		
			 		<th colspan="3" align="left"><%@ include file="../include/ClientInput.jsp"%></th>			 					 				 					 									 		
			 		<th align="right">日期 :</th>
			 		<th align="left"><input type="text" name="formBean.order.order_StartTime" value="<s:date name="formBean.order.order_StartTime" format="yyyy-MM-dd HH:mm:ss" />" readonly size="15"/></th>
			 		<th align="right">上欠 :</th>
			 		<th align="left"><s:textfield name="formBean.order.preAcctAmt" id="preAcct" size="6" readonly="true"/></th>
			 		<th align="left">订单号&nbsp; :&nbsp; <s:property value="formBean.order.order_ID"/> </th>	 
			 	</tr>
			    <tr height="10">
	  	            <th colspan="10"></th>
	            </tr>
			 	<tr class="PBAOuterTableTitale">
			 		<th width="15%">&nbsp;</th>
			 		<th width="5%" align="right">单据输入&nbsp; :</th>   		
			 		<th width="8%" align="left"><s:select name="formBean.order.order_Keeper.user_id" id="keeper_id"  list="uiBean.users" listKey="user_id" listValue="user_name" headerKey="0" headerValue="" /></th>
			 		<th width="5%" align="right">货品扫描&nbsp; :</th>
			 		<th width="8%" align="left"> <s:select name="formBean.order.order_scanner.user_id" id="scanner_id"  list="uiBean.users" listKey="user_id" listValue="user_name" headerKey="0" headerValue="" /></th>
			 		<th width="5%" align="right">货品点数&nbsp; :</th>
			 		<th width="5%" align="left"><s:select name="formBean.order.order_Counter.user_id" id="counter_id"  list="uiBean.users" listKey="user_id" listValue="user_name" headerKey="0" headerValue="" /></th>       
			 		<th width="4%" align="right">下欠 :</th>		 					 				 					 		
			 		<th align="left"><s:textfield name="formBean.order.postAcctAmt" id="postAcct" size="6" readonly="true"/></th>	
			 		<th width="15%" align="left">
			 		       <select name="formBean.fullOrSingle" id="fullOrSingle">
						    <option value="0">齐手</option>
						    <option value="1">单手</option>
						   </select>
			 		</th>							 		
			 	</tr>
				<tr height="10">
					<th colspan="10"></th>
				</tr>			 	
	            <tr>
	                <td colspan="10">
	       <table cellpadding="0" cellspacing="0" style="width: 100%" border="0">
			 	<tr class="PBAOuterTableTitale" height="22">
			 		    <th style="width: 6%">&nbsp;</th>
				 		<th style="width: 9%">条型码</th>			 					 				 		
				 		<th style="width: 8%">产品货号</th>
				 		<th style="width: 4%">颜色</th>
				 		<th style="width: 9%">产品品牌</th>	
				 		<th style="width: 4%">年份</th>	
				 		<th style="width: 4%">季度</th>	
				 		<th style="width: 4%">数量</th>
				 		<th style="width: 5%">单位</th>		
				 		<th style="width: 8%">单价</th>
				 		<th style="width: 5%">折扣</th>
				 		<th style="width: 8%">批发价</th>
				 		<th style="width: 8%">批发价汇总</th>
				 		<th style="width: 4%">&nbsp;</th>	
				 		<th style="width: 10%"></th> 		 		
	                </tr>
	                <tbody  id="inventoryTable">
		                <s:iterator value="formBean.order.product_List" status = "st" id="orderProduct" >
						 	<tr id="row<s:property value="#st.index"/>"  class="excelTable">
						 		<td align="center"><s:property value="#st.index +1"/><input type="hidden" name="formBean.order.product_List[<s:property value="#st.index"/>].ID" value="<s:property value="#orderProduct.ID"/>"/></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.barcode" id="barcode<s:property value="#st.index"/>" readonly="readonly" value="<s:property value="#orderProduct.productBarcode.barcode"/>"  size='10'/>
						 		    <input type="hidden" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.id" id="productId<s:property value="#st.index"/>" readonly="readonly" value="<s:property value="#orderProduct.productBarcode.id"/>"/>					 		</td>			 					 		
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.product.productCode" id="productCode<s:property value="#st.index"/>"  size='8' value="<s:property value="#orderProduct.productBarcode.product.productCode"/>"/><input type="hidden" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.product.numPerHand" id="numPerHand<s:property value="#st.index"/>" readonly="readonly"  value="<s:property value="#orderProduct.productBarcode.product.numPerHand"/>"/></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.color.name" id="color<s:property value="#st.index"/>" readonly="readonly"  size='2' value="<s:property value="#orderProduct.productBarcode.color.name"/>"/></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.product.brand.brand_Name" id="brand<s:property value="#st.index"/>" readonly="readonly"  size='12' value="<s:property value="#orderProduct.productBarcode.product.brand.brand_Name"/>"/></td>			 					 		
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.product.year.year" id="year<s:property value="#st.index"/>" readonly="readonly"  size='2' value="<s:property value="#orderProduct.productBarcode.product.year.year"/>"/></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.product.quarter.quarter_Name" id="quarter<s:property value="#st.index"/>" readonly="readonly"  size='2' value="<s:property value="#orderProduct.productBarcode.product.quarter.quarter_Name"/>"/></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].quantity" id="quantity<s:property value="#st.index"/>" size='2' onchange="onQuantityChange(<s:property value="#st.index"/>);" onfocus="this.select();" value="<s:property value="#orderProduct.quantity"/>"/><s:if test="#orderProduct.moreThanTwoHan">*</s:if></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.product.unit" id="unit<s:property value="#st.index"/>" readonly="readonly"  size='3' value="<s:property value="#orderProduct.productBarcode.product.unit"/>"/></td>			 					 		
						 		<td><select id="priceSlect<s:property value="#st.index"/>" name="formBean.order.product_List[<s:property value="#st.index"/>].salePriceSelected" onchange="onWholeSalePriceChange(3,<s:property value="#st.index"/>);">
							           <option value='<s:property value="#orderProduct.productBarcode.product.wholeSalePrice"/>' <s:if test="#orderProduct.productBarcode.product.wholeSalePrice == #orderProduct.salePriceSelected">selected</s:if>>预设价1 <s:property value="#orderProduct.productBarcode.product.wholeSalePrice"/></option>
									   <option value='<s:property value="#orderProduct.productBarcode.product.wholeSalePrice2"/>' <s:if test="#orderProduct.productBarcode.product.wholeSalePrice2 == #orderProduct.salePriceSelected">selected</s:if>>预设价2 <s:property value="#orderProduct.productBarcode.product.wholeSalePrice2"/></option>
	                                   <option value='<s:property value="#orderProduct.productBarcode.product.wholeSalePrice3"/>' <s:if test="#orderProduct.productBarcode.product.wholeSalePrice3 == #orderProduct.salePriceSelected">selected</s:if>>预设价3 <s:property value="#orderProduct.productBarcode.product.wholeSalePrice3"/></option>
	                                   <option value='<s:property value="#orderProduct.productBarcode.product.salesPriceFactory"/>' <s:if test="#orderProduct.productBarcode.product.salesPriceFactory == #orderProduct.salePriceSelected">selected</s:if>>零售价 <s:property value="#orderProduct.productBarcode.product.salesPriceFactory"/></option>		        
							        </select></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].discount" id="discount<s:property value="#st.index"/>" onchange="onWholeSalePriceChange(1,<s:property value="#st.index"/>);" onfocus='this.select();' size='3' value="<s:property value="#orderProduct.discount"/>"/></td>
						 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].wholeSalePrice" id="wholeSalePrice<s:property value="#st.index"/>" onchange='onWholeSalePriceChange(2,<s:property value="#st.index"/>);'  size='8' value="<s:property value="#orderProduct.wholeSalePrice"/>"   onfocus="this.select();"/></td>			 							 		
						 		<td>
						 		<input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].totalWholeSalePrice" id="totalWholeSalePrice<s:property value="#st.index"/>" readonly="readonly"  size='8' value="<s:text name="format.price"><s:param value="#orderProduct.wholeSalePrice * #orderProduct.quantity"/></s:text>"/>
						 		</td>
						 		<td><div id="delIcon0" style="display:block"><img src="<%=request.getContextPath()%>/conf_files/web-image/delete.png" border="0" onclick="deleteRow('row<s:property value="#st.index"/>',<s:property value="#st.index"/>);"  style="cursor:pointer;"/></div></td>				
						 		<td><div id="takeBefore0" style="display:block;color:red"><s:if test="#orderProduct.productBarcode.boughtBefore > 0">已配<s:property value="#orderProduct.productBarcode.boughtBefore"/></s:if></div><input type="hidden" name="formBean.order.product_List[<s:property value="#st.index"/>].productBarcode.boughtBefore" id="boughtBefore<s:property value="#st.index"/>" size='14' value="0"/></td>
						 		
			                </tr>
		                </s:iterator>
					 	<tr height="22" id="row<s:property value='formBean.order.product_List.size()'/>" class="excelTable">
					 		<td align="center"><s:property value='formBean.order.product_List.size() +1'/></td>
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.barcode" id="barcode<s:property  value='formBean.order.product_List.size()'/>"  size='10'/>
						 	    <input type="hidden" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.id" id="productId<s:property  value='formBean.order.product_List.size()'/>"/>					 	</td>			 					 		
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.product.productCode" id="productCode<s:property value='formBean.order.product_List.size()'/>"  size='8'/><input type="hidden" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.product.numPerHand" id="numPerHand<s:property value='formBean.order.product_List.size()'/>" size='14' value="0"/></td>
					 		<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.color.name" id="color<s:property value='formBean.order.product_List.size()'/>" readonly="readonly"  size='2'/></td>
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.product.brand.brand_Name" id="brand<s:property value='formBean.order.product_List.size()'/>" readonly="readonly"  size='12'/></td>			 					 		
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.product.year.year" id="year<s:property value='formBean.order.product_List.size()'/>" readonly="readonly"  size='2'/></td>
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.product.quarter.quarter_Name" id="quarter<s:property value='formBean.order.product_List.size()'/>" readonly="readonly"  size='2'/></td>
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].quantity" id="quantity<s:property value='formBean.order.product_List.size()'/>" size='2' value="0" onchange="onQuantityChange(<s:property value='formBean.order.product_List.size()'/>);"  onfocus="this.select();"/></td>
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.product.unit" id="unit<s:property value='formBean.order.product_List.size()'/>" readonly="readonly"  size='3'/></td>			 					 		
						 	<td><select id="priceSlect<s:property value='formBean.order.product_List.size()'/>" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].salePriceSelected" onchange="onWholeSalePriceChange(3,<s:property value='formBean.order.product_List.size()'/>);">
							    </select></td>
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].discount" id="discount<s:property value='formBean.order.product_List.size()'/>" onchange="onWholeSalePriceChange(1,<s:property value='formBean.order.product_List.size()'/>);" onfocus='this.select();'  size='3'/></td>
						 	<td><input type="text" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].wholeSalePrice" id="wholeSalePrice<s:property value='formBean.order.product_List.size()'/>"  onchange="onWholeSalePriceChange(2,<s:property value='formBean.order.product_List.size()'/>);"   onfocus="this.select();" size='8'/></td>
					 		<td><input type="text" name="formBean.order.product_List[<s:property value="#st.index"/>].totalWholeSalePrice" id="totalWholeSalePrice<s:property value='formBean.order.product_List.size()'/>" readonly="readonly"  size='8'/>
					 		    </td>
					 		<td><div id="delIcon<s:property value='formBean.order.product_List.size()'/>" style="display:none"><img src="<%=request.getContextPath()%>/conf_files/web-image/delete.png" border="0" onclick="deleteRow('row<s:property value="formBean.order.product_List.size()"/>',<s:property value='formBean.order.product_List.size()'/>);"  style="cursor:pointer;"/></div></td>			 		
		                    <td><div id="inventory<s:property value='formBean.order.product_List.size()'/>" style='display:inline;color:blue'></div>&nbsp;<div id="takeBefore<s:property value='formBean.order.product_List.size()'/>" style="display:inline;color:red"></div><input type="hidden" name="formBean.order.product_List[<s:property value='formBean.order.product_List.size()'/>].productBarcode.boughtBefore" id="boughtBefore<s:property value='formBean.order.product_List.size()'/>" size='14' value="0"/></td>
					 		 </tr>
	                </tbody>
	                <tr class="PBAOuterTableTitale" height="22">
				 		<td align ="center">总计</td>		 					 		
				 		<td></td>
				 		<td></td>	
				 		<td></td>
				 		<td></td>	
				 		<td></td>	
				 		<td></td>		 					 		
				 		<td><s:textfield name="formBean.order.totalQuantity" id="totalQuantity" readonly="true" size='2'/></td>			 					 		
				 		<td></td>
				 		<td>&nbsp;</td>
				 		<td>&nbsp;</td>
				 		<td></td>
				 		<td><s:textfield name="formBean.order.totalWholePrice" id="totalWholePrice" size='8' readonly="true"/></td>
				 		<td>&nbsp;</td>	
				 		<td>&nbsp;</td>		 		
	                </tr>	                
		              </table>  	
	                </td> 
	            </tr>
                <tr height="10">
			         <td colspan="10" align="left"></td>			 					 		
	            </tr>
	            <tr>
	            	<td colspan="10">
			            <table cellpadding="0" cellspacing="0" style="width: 100%" border="0" id="org_table2">
							<tr height="10" class="InnerTableContent" >
							     <td>&nbsp;</td>
							  	 <td>备注</td>
								 <td colspan="13"><textarea name="formBean.order.comment" id="comment" rows="1" cols="80"><s:property value="formBean.order.comment"/></textarea></td>			 					 				 					 		
							</tr>
			                <tr class="InnerTableContent">
			                  <td style="width: 6%" height="27">&nbsp;</td>
			                  <td style="width: 4%">优惠</td>
			                  <td style="width: 6%"><s:textfield name="formBean.order.totalDiscount" id="totalDiscount" size="4" cssClass="easyui-numberbox"  data-options="precision:2,onChange:function(param1, param2){calculateCasher();}"/></td>
			                  <td style="width: 4%">现金</td>
			                  <td style="width: 6%"><s:textfield name="formBean.order.cash" id="cash" size="4" cssClass="easyui-numberbox"  data-options="onChange:function(param1, param2){calculateCasher();}"/></td>
			                  <td style="width: 4%">刷卡</td>
			                  <td style="width: 6%"><s:textfield name="formBean.order.card" id="card" size="4" cssClass="easyui-numberbox"  data-options="onChange:function(param1, param2){calculateCasher();}"/></td>
			                  <td style="width: 4%">支付宝</td>
			                  <td style="width: 6%"><s:textfield name="formBean.order.alipay" id="alipay" size="4" cssClass="easyui-numberbox"  data-options="onChange:function(param1, param2){calculateCasher();}"/></td>
			                  <td style="width: 4%">微信</td>
			                  <td style="width: 6%"><s:textfield name="formBean.order.wechat" id="wechat" size="4" cssClass="easyui-numberbox"  data-options="onChange:function(param1, param2){calculateCasher();}"/></td>
			                  <td style="width: 6%">待付/待收金额</td>
			                  <td style="width: 8%"><input type="text" id="casher" size="4" class="easyui-numberbox"  data-options="precision:2" readonly/></td>
			                  <td style="width: 25%">&nbsp;</td>
			                  <td>&nbsp;</td>
			                </tr>
		                </table>
	            	</td>
	            </tr>

		 </table>
	     </td>
	  </tr>
