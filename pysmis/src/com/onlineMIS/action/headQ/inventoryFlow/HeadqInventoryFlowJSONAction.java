package com.onlineMIS.action.headQ.inventoryFlow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.springframework.beans.factory.annotation.Autowired;

import com.onlineMIS.ORM.DAO.Response;
import com.onlineMIS.ORM.DAO.chainS.chainMgmt.ChainMgmtService;
import com.onlineMIS.ORM.DAO.chainS.inventoryFlow.ChainInventoryFlowOrderService;
import com.onlineMIS.ORM.DAO.headQ.barCodeGentor.ProductBarcodeService;
import com.onlineMIS.ORM.entity.chainS.chainMgmt.ChainInitialStock;
import com.onlineMIS.ORM.entity.chainS.inventoryFlow.ChainInventoryFlowOrder;
import com.onlineMIS.ORM.entity.chainS.inventoryFlow.ChainInventoryFlowOrderProduct;
import com.onlineMIS.ORM.entity.chainS.user.ChainUserInfor;
import com.onlineMIS.ORM.entity.headQ.inventory.InventoryOrder;
import com.onlineMIS.ORM.entity.headQ.inventory.InventoryOrderProduct;
import com.onlineMIS.ORM.entity.headQ.user.UserInfor;
import com.onlineMIS.action.BaseAction;
import com.onlineMIS.common.Common_util;
import com.onlineMIS.common.loggerLocal;
import com.onlineMIS.converter.JSONSQLDateConverter;
import com.onlineMIS.converter.JSONUtilDateConverter;
import com.opensymphony.xwork2.ActionContext;

/**
 * action to 
 * @author fredo
 *
 */
@SuppressWarnings("serial")
public class HeadqInventoryFlowJSONAction extends HeadqInventoryFlowAction{

	
	private JSONObject jsonObject;
	private JSONArray jsonArray;
	private Map<String,Object> jsonMap = new HashMap<String, Object>();

	public JSONObject getJsonObject() {
		return jsonObject;
	}
	public void setJsonObject(JSONObject jsonObject) {
		this.jsonObject = jsonObject;
	}
	
	
	public JSONArray getJsonArray() {
		return jsonArray;
	}
	public void setJsonArray(JSONArray jsonArray) {
		this.jsonArray = jsonArray;
	}
	public String getInventoryFlowEles(){
		loggerLocal.info("HeadqInventoryFlowJSONAction - getInventoryFlowEles");
		Response response = new Response();

		try {
		    response = headqInventoryService.getHeadqInventory(formBean.getParentId(), formBean.getStoreId(), formBean.getYearId(), formBean.getQuarterId(), formBean.getBrandId());
		} catch (Exception e){
			e.printStackTrace();
		}	
		
		try{
			   jsonArray = JSONArray.fromObject(response.getReturnValue());
			   //System.out.println(jsonArray);
			} catch (Exception e){
				e.printStackTrace();
			}	
		
		return "jsonArray";
	}
	
	/**
	 * 在总部库存单据中，通过条码查找货品
	 * @return
	 */
	public String scanByBarcodeInvenFlowOrder(){
		UserInfor loginUserInfor = (UserInfor)ActionContext.getContext().getSession().get(Common_util.LOGIN_USER);
		loggerLocal.info(loginUserInfor.getUser_name() + " : SupplierPurchaseJSONAction.scanByBarcodeInvenFlowOrder");
		
		Response  response = headqInventoryService.scanByBarcodeInvenOrder(formBean.getPb().getBarcode(),  formBean.getIndexPage(), formBean.getFromSrc());

		jsonMap = (Map<String, Object>)response.getReturnValue();

		jsonObject = ProductBarcodeService.transferProductBarcode(jsonMap, null);	
		
		return SUCCESS;
	}
	
}
