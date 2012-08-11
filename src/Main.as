package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.display.Graphics;
	import flash.utils.ByteArray;
	import flash.display.LoaderInfo;
	import flash.display.NativeWindowResize;
	import flash.display.NativeWindow;  
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	/**
	 * ...
	 * @author Adrian Seeley
	 */
	
	public class Main extends Sprite 
	{
		private static var workingDirectoryTop:File;
		private static var workingFilesToLoad:Array;
		private static var workingFilesLeftToLoad:int;
		private static var workingBitmaps:Array;
		
		private static var ui_pixieLabel:TextField;
		private static var ui_workingDirectoryTopLabel:TextField;
		private static var ui_FilesFoundInDirectoryCountLabel:TextField;
		private static var ui_headerInfoLabel:TextField;
		private static var ui_select_folderButton:SimpleButton;
		private static var ui_createButton:SimpleButton;
		private static var ui_tickToLabel:TextField;
		private static var ui_tickToTextField:TextField;
		
		public static function GetAlphabeticalOrder(a:String, b:String):int
		{
			// Returns -1 if a then b
			// Returns  0 if a  ==  b
			// Returns +1 if b then a
			
			var pos:uint = 0;
			while (a.charCodeAt(pos) == b.charCodeAt(pos))
			{
				pos++;
			}
			
			var num1:uint = a.charCodeAt(pos);
			var num2:uint = b.charCodeAt(pos);
			
			if (isNaN(num1))
			{
				num1 = 0;
			}
			if (isNaN(num2))
			{
				num2 = 0;
			}
			if (num1 < num2)
			{
				return -1;
			} 
			else if (num1 > num2) 
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		public function Main():void 
		{		
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.nativeWindow.width = 600;
			stage.nativeWindow.height = 340;

			buildUI();
		}
		
		private function buildUI():void
		{
			// Fill the background
			graphics.beginFill( 0x121212 );
			graphics.drawRect(0, 0, stage.stageWidth * 2, stage.stageHeight * 2);
			graphics.endFill();

			// Make title
			ui_pixieLabel 		   = new TextField();
			ui_pixieLabel.autoSize = "left";
			ui_pixieLabel.htmlText = "<font size='64' color='#AAAAEE'>Pixie</font>";
			ui_pixieLabel.selectable = false;
			addChild(ui_pixieLabel);
			
			// Make working directory label
			ui_workingDirectoryTopLabel 	      = new TextField();
			ui_workingDirectoryTopLabel.autoSize  = "left";
			ui_workingDirectoryTopLabel.multiline = false;
			ui_workingDirectoryTopLabel.htmlText  = "<font size='16' color='#EEEEEE'>Please select a directory.</font>";
			addChild(ui_workingDirectoryTopLabel);
			
			// Make files found count
			ui_FilesFoundInDirectoryCountLabel 			 = new TextField();
			ui_FilesFoundInDirectoryCountLabel.autoSize  = "left";
			ui_FilesFoundInDirectoryCountLabel.multiline = false;
			ui_FilesFoundInDirectoryCountLabel.htmlText  = "";
			addChild(ui_FilesFoundInDirectoryCountLabel);
			
			// Make header info label
			ui_headerInfoLabel 			 = new TextField();
			ui_headerInfoLabel.autoSize  = "left";
			ui_headerInfoLabel.multiline = true;
			ui_headerInfoLabel.htmlText  = "";
			addChild(ui_headerInfoLabel);
			
			// Make selecct folder button
			ui_select_folderButton = new SimpleButton(new res_btn_select_folder_upState(), new res_btn_select_folder_overState(), new res_btn_select_folder_downState(), new res_btn_select_folder_upState());
			ui_select_folderButton.useHandCursor = true;
			ui_select_folderButton.addEventListener(MouseEvent.CLICK, Click_Select_Folder);
			addChild(ui_select_folderButton);
			
			// Make create button
			ui_createButton = new SimpleButton(new res_btn_create_upState() , new res_btn_create_overState(), new res_btn_create_downState(), new res_btn_create_upState());
			ui_createButton.useHandCursor = true;
			ui_createButton.addEventListener(MouseEvent.CLICK, Click_Create);
			addChild(ui_createButton);
			
			// Make tick to label
			ui_tickToLabel = new TextField();
			ui_tickToLabel.autoSize = "right";
			ui_tickToLabel.text = "Animation Latency: ";
			ui_tickToLabel.textColor = 0xEEEEEE;
			ui_tickToLabel.selectable = false;
			addChild(ui_tickToLabel);
			
			// Make tick to textfield
			ui_tickToTextField = new TextField();
			ui_tickToTextField.autoSize = "center";
			ui_tickToTextField.text = "10";
			ui_tickToTextField.border = true;
			ui_tickToTextField.backgroundColor = 0xEEEEEE;
			ui_tickToTextField.background = true;
			ui_tickToTextField.restrict = "0123456789";
			ui_tickToTextField.type = "input";
			addChild(ui_tickToTextField);
			
			// Layout
			layout();
		}
		private function layout():void
		{
			ui_pixieLabel.x 	   				  = 16;
			ui_pixieLabel.y 	   				  = 16;

			ui_tickToLabel.x 					  = ui_pixieLabel.x;
			ui_tickToLabel.y 					  = ui_pixieLabel.y + ui_pixieLabel.height;
			
			ui_tickToTextField.x 				  = ui_tickToLabel.x + ui_tickToLabel.width;
			ui_tickToTextField.y 				  = ui_tickToLabel.y;
			
			ui_workingDirectoryTopLabel.x 	      = ui_tickToLabel.x;
			ui_workingDirectoryTopLabel.y 		  = ui_tickToLabel.y + ui_tickToLabel.height;
			
			ui_FilesFoundInDirectoryCountLabel.x  = ui_workingDirectoryTopLabel.x;
			ui_FilesFoundInDirectoryCountLabel.y  = ui_workingDirectoryTopLabel.y + ui_workingDirectoryTopLabel.height;
			
			ui_headerInfoLabel.x 		 		  = ui_FilesFoundInDirectoryCountLabel.x;
			ui_headerInfoLabel.y 		 		  = ui_FilesFoundInDirectoryCountLabel.y + ui_FilesFoundInDirectoryCountLabel.height;
			
			ui_select_folderButton.x 			  = ui_pixieLabel.x + ui_pixieLabel.width;
			ui_select_folderButton.y 			  = ui_pixieLabel.y;
			
			ui_createButton.x  					  = ui_select_folderButton.x + ui_select_folderButton.width;
			ui_createButton.y 					  = ui_select_folderButton.y;
		}
		
		private function Click_Select_Folder(e:MouseEvent):void
		{
			browseForNewWorkingDirectory();
		}
		private function Click_Create(e:MouseEvent):void
		{
			if (workingDirectoryTop != null && workingDirectoryTop.exists && workingDirectoryTop.isDirectory)
			{
				BuildPixieSheet();
			}
		}
		
		private function browseForNewWorkingDirectory():void
		{
			workingDirectoryTop = new File();
			cleanupBrowseForNewWorkingDirectoryListeners();
			workingDirectoryTop.addEventListener(Event.SELECT, workingDirectoryTopSelected);
			workingDirectoryTop.addEventListener(Event.CANCEL, workingDirectoryTopCancelled);
			workingDirectoryTop.browseForDirectory("Choose a folder of frames to convert to Pixie Sheet:");
		}
		private function workingDirectoryTopSelected(e:Event):void
		{
			cleanupBrowseForNewWorkingDirectoryListeners();
			
			// Confirm user has selected a folder
			if (!workingDirectoryTop.exists)
			{
				throw new Error("The selected directory does not appear to exist, the app will now crash horribly, please restart.");
			}
			
			// Display the selected working directory
			ui_workingDirectoryTopLabel.htmlText = "<font size='16' color='#EEEEEE'>Selected Directory: </font><font size='16' color='#AAEE00'>" + workingDirectoryTop.url + "</font>";
			
			// Pull the images from the directory
			PullImageNamesFromDirectory(workingDirectoryTop);
		}
		private function workingDirectoryTopCancelled(e:Event):void
		{
			// If the user cancels selecting a folder to convert, show the dialog again
			//browseForNewWorkingDirectory();
			
			// If the user cancels selecting a folder to convert, close the app
			stage.nativeWindow.close();
		}
		private function cleanupBrowseForNewWorkingDirectoryListeners():void 
		{
			workingDirectoryTop.removeEventListener(Event.SELECT, workingDirectoryTopSelected);
			workingDirectoryTop.removeEventListener(Event.CANCEL, workingDirectoryTopCancelled);
		}
		private function PullImageNamesFromDirectory(Directory:File):void
		{
			// Note: this function will not search subfolders
			
			workingFilesToLoad = new Array();
			var workingDirectoryContents:Array = workingDirectoryTop.getDirectoryListing();
			for each (var file:File in workingDirectoryContents)
			{
				if (file.isDirectory)
				{
					// Handle subfolders here if need be, we dont do that for now, there is a note at the entry of this function
				}
				else
				{
					if (file.extension.toLowerCase() == "png")
					{
						// We support png, load it, add it
						workingFilesToLoad.push(file);
					}
					else
					{
						trace("not png");
					}
				}
			}
			
			// Ensure we got at least two images
			if (workingFilesToLoad.length < 2)
			{
				throw new Error("Found less than two images in the specified directory, need at least two images to build a sheet, crash central station");
			}
			
			// Set the monitor for how many files we have left to load
			workingFilesLeftToLoad = workingFilesToLoad.length;
			
			// Display files found to user
			ui_FilesFoundInDirectoryCountLabel.htmlText =  "<font size='16' color='#EEAAAA'>  " + workingFilesToLoad.length + "</font><font size='16' color='#EEEEEE'> png files found.</font>"
			
			// Create working bitmaps array
			workingBitmaps = new Array();
			
			// Start loading all files
			for (var iter:int = 0; iter < workingFilesToLoad.length; iter++)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, FileLoaded);
				loader.load(new URLRequest(workingFilesToLoad[iter].url));
			}
		}
		private function FileLoaded(e:Event):void
		{
			// Note: since loading is not guaranteed to complete in any order whatsoever, we store all the bitmaps into working with their url intact
			
			// Add the bitmap to working now that its loaded
			workingBitmaps.push(new Array(LoaderInfo(e.target).url, Bitmap(LoaderInfo(e.target).content)));
			
			// Decrement remaining count
			workingFilesLeftToLoad -= 1;
			
			// If we have no files left to load proceed
			if (workingFilesLeftToLoad == 0)
			{
				// All image files have been loaded
				AllFilesLoaded();
			}
		}
		private function AllFilesLoaded():void
		{
			// Now inside of workingBitmaps we have a nested array with (URL, bitmap)
			// Because images are loaded in whatever willy-nilly order air likes to load them in, we sort them by url name
			
			// Sort urls by name
			for (var iter:int = 0; iter < workingBitmaps.length - 1; iter++)
			{
				// Make sure names arent the same
				if (workingBitmaps[iter][0] == workingBitmaps[iter +1][0])
				{
					throw Error("Error trying to order bitmaps, two bitmaps have the same url name, we can't order two things that are the same, craaaash");
				}
				
				var alphabeticalOrder:int = GetAlphabeticalOrder(workingBitmaps[iter][0], workingBitmaps[iter + 1][0]);
				switch(alphabeticalOrder)
				{
					// a then b
					case -1:
						// In order
						continue;
						break;
					// a  ==  b
					case 0:
						// Error congurency
						throw Error("Error trying to order bitmaps, two bitmaps have the same url name, we can't order two things that are the same, craaaash");
						break;
					// b then a
					case 1:
						// Swap a and b
						var temp:Array = workingBitmaps[iter];
						workingBitmaps[iter] = workingBitmaps[iter + 1];
						workingBitmaps[iter + 1] = temp;
						
						// Restart iter
						iter = -1; 	//-1 as iter++ will increment to 0
						continue;
						break;
				}
			}
			
			// Working bitmaps are in alphabetical order! Trim urls from array
			for (var iter2:int = 0; iter2 < workingBitmaps.length; iter2++)
			{
				workingBitmaps[iter2] = workingBitmaps[iter2][1];
			}
			
			// workingBitmaps now only contains the proper order of bitmap images
			AllFilesInOrder();
		}
		
		private function AllFilesInOrder():void
		{
			// Fix layout
			layout();
		}
		
		private function BuildPixieSheet():void
		{
			// Build a new pixie sheet!
			var sheet:PixieSheet = new PixieSheet(workingBitmaps, int(ui_tickToTextField.text), workingDirectoryTop.name)
			
			// Creating a sheet prompts to save, the user will have already saved reaching this point
			
			//Spit out header data
			ui_headerInfoLabel.htmlText = "<font size='16' color='#EEEEEE'>Pixie Sheet Embedded Header Information:<br></font>" +
										  "<font size='16' color='#EEEEEE'>  Frame Width: </font><font size='16' color='#EEAAAA'>" + sheet.header.info_FrameWidth +" px<br></font>" +
										  "<font size='16' color='#EEEEEE'>  Frame Height: </font><font size='16' color='#EEAAAA'>" + sheet.header.info_FrameHeight +" px<br></font>" +
										  "<font size='16' color='#EEEEEE'>  Total Frames: </font><font size='16' color='#EEAAAA'>" + sheet.header.info_FrameCountTotal +" frames<br></font>" +
										  "<font size='16' color='#EEEEEE'>  Columns of Frames: </font><font size='16' color='#EEAAAA'>" + sheet.header.info_FrameCountAcross +" columns<br></font>" +
										  "<font size='16' color='#EEEEEE'>  Rows of Frames: </font><font size='16' color='#EEAAAA'>" + sheet.header.info_FrameCountDown +" rows<br></font>" +
										  "<font size='16' color='#EEEEEE'>  Tick To (Latency): </font><font size='16' color='#EEAAAA'> wait " + sheet.header.info_FrameTickTo +" frames, then move to next</font>";
		
		}
	}
	
}