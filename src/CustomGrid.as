package
{
	import com.flexicious.nestedtreedatagrid.FlexDataGrid;
	import com.flexicious.nestedtreedatagrid.events.FlexDataGridEvent;
	import com.flexicious.nestedtreedatagrid.interfaces.IFlexDataGridCell;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.managers.ToolTipManager;
	
	public class CustomGrid extends FlexDataGrid
	{
		public function CustomGrid()
		{
			super();
		}
		
		/**
		 * If enable custom right click is true, we handle it in this function.
		 */		
		protected override function onRightClick(event:MouseEvent):void
		{
//			if(enableRightClickSelectRow){
//				this.currentCell = this.getCellFromMouseEventTarget(event.target) || currentCell;
//				if(this.currentCell){
//					this.currentCell.level.selectRow(this.currentCell.rowInfo, true, true);
//					this.highlightRow(this.currentCell,this.currentCell.rowInfo,true);
//				}
//			}
			if(ToolTipManager.currentToolTip){
				ToolTipManager.destroyToolTip(ToolTipManager.currentToolTip);
				ToolTipManager.currentToolTip=null;
			}
			//we are over a column header
			var items:Array=[];
			if(currentCell is IFlexDataGridCell ){ 
				//contextMenu.customItems=cmis; 
				items.push({caption:this.copyCellMenuText});
				items.push({caption:this.copySelectedRowMenuText});
				items.push({caption:this.copyAllRowsMenuText});
				items.push({caption:this.isRowSelectionMode?copySelectedRowsMenuText:copySelectedCellsMenuText});
			}
			if(currentCell)
			{
				var evt:FlexDataGridEvent = new FlexDataGridEvent(FlexDataGridEvent.ITEM_RIGHT_CLICK, this, currentCell.level, currentCell.column, currentCell, currentCell.rowInfo.data,event);
				dispatchEvent(evt);
			}
			for each(var rightClickItem:Object in customContextMenuItems)
			{
				if(rightClickItem is String)
				{
					items.push({caption:rightClickItem});	
				}
				else
				{
					items.push(rightClickItem);
				}
				
				
			}
			if(items.length>0){
				customContextMenu.labelField = "caption";
				customContextMenu.dataProvider=items;
				
				if(customContextMenu.visible){
					customContextMenu.hide();
				}
				var popUpGap:int=0;
				
				var point:Point = new Point(event.stageX, event.stageY);
				
				var ht:Number=customContextMenu.height || (items.length*21);
				var wd:Number=customContextMenu.width || (250);
				
				
				if (point.y + ht > screen.bottom && 
					point.y > (screen.top + ht))
				{ 
					// PopUp will go below the bottom of the stage
					// and be clipped. Instead, have it grow up.
					point.y -= (ht + 2*popUpGap);
				}
				if (point.x + wd > screen.right && 
					point.x > (screen.left + wd))
				{ 
					// PopUp will go below the bottom of the stage
					// and be clipped. Instead, have it grow up.
					point.x -= (wd + 2*popUpGap);
				}
				customContextMenu.show(point.x,point.y);				
			}
			cellUnderRightClick=currentCell;
		}
	}
}