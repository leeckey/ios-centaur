/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.swf.structures
{
	public class FillStyle
	{
		private var _fillStyleType:uint = FillStyleTypeConstants.SOLID_FILL;
		private var _color:RGBA = new RGBA(); // Ignore ALPHA if Shape1 or Shape2
		private var _matrix:Matrix = new Matrix();
		private var _gradient:FocalGradient = new FocalGradient();
		private var _bitmapId:uint = 0;
		private var _bitmapMatrix:Matrix = new Matrix();
		
		public function get fillStyleType():uint
		{
			return _fillStyleType;
		}
		
		public function set fillStyleType(value:uint):void
		{
			_fillStyleType = value;
		}
		
		/**
		 * Swfassist ignores ALPHA if this record is part of Shape1 or Shape2.
		 */
		public function get color():RGBA
		{
			return _color;
		}
		
		public function set color(value:RGBA):void
		{
			_color = value;
		}
		
		public function get matrix():Matrix
		{
			return _matrix;
		}
		
		public function set matrix(value:Matrix):void
		{
			_matrix = value;
		}
		
		/**
		 * Swfassist ignores FocalPoint if the FillStypeType is not FOCAL_GRADIENT_FILL.
		 */
		public function get gradient():FocalGradient
		{
			return _gradient;
		}
		
		public function set gradient(value:FocalGradient):void
		{
			_gradient = value;
		}
		
		public function get bitmapId():uint
		{
			return _bitmapId;
		}
		
		public function set bitmapId(value:uint):void
		{
			_bitmapId = value;
		}
		
		public function get bitmapMatrix():Matrix
		{
			return _bitmapMatrix;
		}
		
		public function set bitmapMatrix(value:Matrix):void
		{
			_bitmapMatrix = value;
		}
	}
}