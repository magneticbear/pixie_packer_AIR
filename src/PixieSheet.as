package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.filesystem.*;
	import flash.net.*;
	
	/**
	 * ...
	 * @author Adrian Seeley
	 */
	public class PixieSheet extends Bitmap 
	{
		public var header:Header;
		
		public function PixieSheet(AllFramesForSheet:Array, FrameTickTo:int, OutputNameSeed:String) 
		{
			// Validate Frames Given
			Validation_Frames(AllFramesForSheet);
			
			// Create data about collection of frames
			var info_FrameWidth:int       = AllFramesForSheet[0].bitmapData.width;										    // The width of each frame of animation
			var info_FrameHeight:int 	  = AllFramesForSheet[0].bitmapData.height;										    // The height of each frame of animation
			var info_FrameCountTotal:int  = AllFramesForSheet.length;														// The total amount of frames in the sheet
			var info_FrameCountAcross:int = int(Math.floor(Math.sqrt(Number(info_FrameCountTotal))));						// The total amount of columns in the sheet
			var info_FrameCountDown:int   = int(Math.ceil(Number(info_FrameCountTotal) / Number(info_FrameCountAcross)));	// The total amount of rows in the sheet
			var info_FrameTickTo:int      = FrameTickTo;
			
			// Create header
			header = new Header(info_FrameWidth, info_FrameHeight, info_FrameCountTotal, info_FrameCountAcross, info_FrameCountDown, info_FrameTickTo);
			
			// Setup bitmap data large enough to hold all frames AND the header
			// 1 + is for the header x
			// 6 ints are packed we need 6 rows
			super(new BitmapData(1 + (info_FrameWidth * info_FrameCountAcross), (6 > (info_FrameHeight * info_FrameCountDown) ? 6 : (info_FrameHeight * info_FrameCountDown)), true, 0xFF0000));
			
			// Place header bitmap into final sheet
			var headerBMP:Bitmap = header.GetHeaderBitmap();
			bitmapData.draw(headerBMP);
			
			// Place all frames into final sheet
			for (var y:int = 0; y < info_FrameCountDown; y++)
			{
				for (var x:int = 0; x < info_FrameCountAcross; x++)
				{
					// Calculate which frame we are on
					var currentFrameNumber:int = x + (y * info_FrameCountAcross);
					
					// If this frame doesnt exist exit out
					if (currentFrameNumber >= info_FrameCountTotal)
					{
						break;
					}
					// Else this frame does exist, place it onto sheet
					else
					{
						// Blit frame to sheet at proper translation
						bitmapData.draw(AllFramesForSheet[currentFrameNumber], new Matrix(1, 0, 0, 1, 1 + (x * info_FrameWidth), y * info_FrameHeight));
					}
				}
			}
			
			// Sheet is now complete, encode
			var png:ByteArray = PNGEncoder.encode(bitmapData);
			
			// Get user to choose a file
			var fileref:FileReference = new FileReference();
			fileref.save(png, OutputNameSeed + ".png");
			
		}
		private function Validation_Frames(AllFramesForSheet:Array):void
		{
			// Ensure we have at least 2 bitmaps, if there is only 1 there is no reason for a sheet
			if (!Validation_EnsureArrayHasAtLeastTwo(AllFramesForSheet))
			{
				throw Error("Trying to construct a PixieSheet object with an array of less than 2 frames, if you only have 1 frame you dont need a sheet, crash time is now");
			}
			// Ensure we have only bitmaps
			if (!Validation_EnsureArrayIsAllBitmapObjects(AllFramesForSheet))
			{
				throw Error("Trying to construct a PixieSheet object with an array of frames that is not all Bitmap objects, crash time is now");
			}
			// Ensure all bitmaps are the same size
			if (!Validation_EnsureAllBitmapObjectsAreSameSize(AllFramesForSheet))
			{
				throw Error("Trying to construct a PixieSheet object with an array of frames that are not all the same size, frames must all be the same size, crash time is now");
			}
		}
		private function Validation_EnsureArrayHasAtLeastTwo(AllFramesForSheet:Array):Boolean
		{
			if (AllFramesForSheet.length < 2)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		private function Validation_EnsureArrayIsAllBitmapObjects(ArrayToValidate:Array):Boolean
		{
			for (var iter:int = 0; iter < ArrayToValidate.length; iter++)
			{
				if (!ArrayToValidate[iter] is Bitmap)
				{
					return false;
				}
			}
			// Reaching here means we did not enounter any non bitmap objects in the array, validated!
			return true;
		}
		private function Validation_EnsureAllBitmapObjectsAreSameSize(ArrayToValidate:Array):Boolean
		{
			// All bitmaps sizes must equal the size of the first bitmap
			for (var iter:int = 1; iter < ArrayToValidate.length; iter++)
			{
				var ls:BitmapData = ArrayToValidate[iter].bitmapData;
				var rs:BitmapData = ArrayToValidate[0].bitmapData;
				if (ls.width != rs.width || ls.height != rs.height)
				{
					return false;
				}
			}
			// Reaching here means we did not enounter any non bitmap objects in the array, validated!
			return true;
		}
	}

}