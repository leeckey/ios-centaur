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

package org.libspark.swfassist.swf.tags
{
	import org.libspark.swfassist.swf.filters.FilterList;
	import org.libspark.swfassist.swf.filters.BlendModeConstants;
	
	public class PlaceObject3 extends PlaceObject2
	{
		public function PlaceObject3(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_PLACE_OBJECT3);
		}
		
		private var _hasImage:Boolean = false;
		private var _hasClassName:Boolean = false;
		private var _hasCacheAsBitmap:Boolean = false;
		private var _hasBlendMode:Boolean = false;
		private var _hasFilterList:Boolean = false;
		private var _className:String = null;
		private var _filterList:FilterList = new FilterList();
		private var _blendMode:uint = BlendModeConstants.NORMAL;
		
		public function get hasImage():Boolean
		{
			return _hasImage;
		}
		
		public function set hasImage(value:Boolean):void
		{
			_hasImage = value;
		}
		
		public function get hasClassName():Boolean
		{
			return _hasClassName;
		}
		
		public function set hasClassName(value:Boolean):void
		{
			_hasClassName = value;
		}
		
		public function get hasCacheAsBitmap():Boolean
		{
			return _hasCacheAsBitmap;
		}
		
		public function set hasCacheAsBitmap(value:Boolean):void
		{
			_hasCacheAsBitmap = value;
		}
		
		public function get hasBlendMode():Boolean
		{
			return _hasBlendMode;
		}
		
		public function set hasBlendMode(value:Boolean):void
		{
			_hasBlendMode = value;
		}
		
		public function get hasFilterList():Boolean
		{
			return _hasFilterList;
		}
		
		public function set hasFilterList(value:Boolean):void
		{
			_hasFilterList = value;
		}
		
		public function get className():String
		{
			return _className;
		}
		
		public function set className(value:String):void
		{
			_className = value;
		}
		
		public function get filterList():FilterList
		{
			return _filterList;
		}
		
		public function set filterList(value:FilterList):void
		{
			_filterList = value;
		}
		
		public function get blendMode():uint
		{
			return _blendMode;
		}
		
		public function set blendMode(value:uint):void
		{
			_blendMode = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitPlaceObject3(this);
		}
	}
}