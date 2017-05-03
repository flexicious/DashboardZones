package com.flexicious.sample.pdf
{
	import com.flexicious.components.dashboard.DashboardContainer;
	import com.flexicious.print.PrintOptions;
	import com.flexicious.print.printareas.PageSize;
	import com.flexicious.utils.UIUtils;
	
	import flash.display.DisplayObject;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pages.Page;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;

	public class AlivePdfGenerator
	{
		public function AlivePdfGenerator()
		{
		}
		
		public function generate(grid:DashboardContainer,printOptions:PrintOptions):void{
			
			var isLandscapse:Boolean=printOptions.pageSize.isLandscape;
			var pdfObject:PDF = new PDF(printOptions.pageSize.isLandscape?PageSize.PAGE_LAYOUT_LANDSCAPE:
				PageSize.PAGE_LAYOUT_POTRAIT,Unit.MM,Size.getSize(printOptions.pageSize.name));
			
			for each(var displayObject:Image in printOptions.printedPages)
			{
				//now that we have the printed images in memory,
				//send them to alivepdf.
				UIUtils.addChild((grid as DisplayObject).parent,displayObject);//need to add it to the stage so it renders
				var page:Page=pdfObject.addPage();
				
				var alivePdfSize:Size = Size.getSize(printOptions.pageSize.name);                    
				pdfObject.addImage(displayObject,null,0,0,alivePdfSize.mmSize[isLandscapse?1:0]-(20),
					alivePdfSize.mmSize[isLandscapse?0:1]-(20),0,1,false); //account for pdf page padding of 20 px
			}
			//small script to echo back the bytes of the pdf, you may use the flexicious Echo,
			//but it is recommended that you implement this inside your own firewall for performance.
			//pdfObject.save( Method.REMOTE, "http://www.flexicious.com/Home/EchoPdf", "Report.pdf" );
			
			//For local persistence of PDF - uncomment this section and comment the line above.
			//Ensure that you are targeting Flash Player 10
			//You will also need to pull in the appropriate imports
			var fileReference:FileReference = new FileReference();
			var bytes:ByteArray = pdfObject.save(Method.LOCAL);
			fileReference.save(bytes, printOptions.pdfFileName);
			
			
			for each( displayObject in printOptions.printedPages)
				UIUtils.removeChild((grid as DisplayObject).parent,displayObject);//remove it as soon as possible
			printOptions.printedPages.removeAll();//now that we're done, remove it from memory.

		}
	}
}