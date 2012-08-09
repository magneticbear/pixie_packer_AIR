package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Adrian Seeley
	 */
	public class Header 
	{
		public var info_FrameWidth:int;			// The width of each frame of animation
		public var info_FrameHeight:int;		// The height of each frame of animation
		public var info_FrameCountTotal:int;	// The total amount of frames in the sheet
		public var info_FrameCountAcross:int;	// The total amount of columns in the sheet
		public var info_FrameCountDown:int;		// The total amount of rows in the sheet
			
		public function Header(FrameWidth:int, FrameHeight:int, FrameCountTotal:int, FrameCountAcross:int, FrameCountDown:int) 
		{
			info_FrameWidth 	  = FrameWidth;
			info_FrameHeight 	  = FrameHeight;
			info_FrameCountTotal  = FrameCountTotal;
			info_FrameCountAcross = FrameCountAcross;
			info_FrameCountDown   = FrameCountDown;
		}
		
		public function GetHeaderBitmap():Bitmap
		{
			// Create bitmap for header
			var headerBitmapData:BitmapData = new BitmapData(1, 5, true, 0xFFFFFFFF);
			
			// Pack data into header
			PackInt(info_FrameWidth, 	   headerBitmapData, 0, 0);
			PackInt(info_FrameHeight, 	   headerBitmapData, 0, 1);
			PackInt(info_FrameCountTotal,  headerBitmapData, 0, 2);
			PackInt(info_FrameCountAcross, headerBitmapData, 0, 3);
			PackInt(info_FrameCountDown,   headerBitmapData, 0, 4);
			
			
			// Return header bitmap
			return new Bitmap(headerBitmapData);
		}
		private function PackInt(ValueToPack:int, BitmapDataToPackInto:BitmapData, PackLocation_X:int, PackLocation_Y:int):void
		{
			var packableColorData:uint = ValueToPack;
			BitmapDataToPackInto.setPixel(PackLocation_X, PackLocation_Y, packableColorData);
		}
		
	}

}