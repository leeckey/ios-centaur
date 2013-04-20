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
	public class LineStyle
	{
		private var _width:uint = 20;
		private var _color:RGBA = new RGBA();
		
		public function get width():Number
		{
			return widthTwips / 20;
		}
		
		public function set width(value:Number):void
		{
			widthTwips = value * 20;
		}
		
		public function get widthTwips():uint
		{
			return _width;
		}
		
		public function set widthTwips(value:uint):void
		{
			_width = value;
		}
		
		/**
		 * Swfassist ignores ALPHA if this class defined at Shape1 or Shape2.
		 */
		public function get color():RGBA
		{
			return _color;
		}
		
		public function set color(value:RGBA):void
		{
			_color = value;
		}
	}
}