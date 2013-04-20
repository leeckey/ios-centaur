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

package org.libspark.swfassist.io
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ByteArrayInputStream implements DataInput
	{
		public function ByteArrayInputStream(input:ByteArray = null)
		{
			if (!input) {
				input = new ByteArray();
			}
			
			this.byteArray = input;
			
			resetBitCursor();
		}
		
		private var _byteArray:ByteArray;
		private var _bitCursor:uint;
		private var _bitBuffer:uint;
		
		public function get byteArray():ByteArray
		{
			return _byteArray;
		}
		
		public function set byteArray(value:ByteArray):void
		{
			if (_byteArray == value) {
				return;
			}
			
			_byteArray = value;
			
			value.endian = Endian.LITTLE_ENDIAN;
			value.position = 0;
		}
		
		public function get bytesAvaliable():uint
		{
			return byteArray.bytesAvailable;
		}
		
		public function get length():uint
		{
			return byteArray.length;
		}
		
		public function get position():uint
		{
			return byteArray.position;
		}
		
		public function set position(value:uint):void
		{
			byteArray.position = value;
		}
		
		public function readS8():int
		{
			return byteArray.readByte();
		}
		
		public function readS16():int
		{
			return byteArray.readShort();
		}
		
		public function readS32():int
		{
			return byteArray.readInt();
		}
		
		public function readU8():uint
		{
			return byteArray.readUnsignedByte();
		}
		
		public function getU8():uint
		{
			return byteArray[position];
		}
		
		public function readU16():uint
		{
			return byteArray.readUnsignedShort();
		}
		
		public function readU32():uint
		{
			return byteArray.readUnsignedInt();
		}
		
		public function readFixed():Number
		{
			return readS32() / 65536;
		}
		
		public function readFixed8():Number
		{
			return readS16() / 256;
		}
		
		public function readFloat16():Number
		{
			var val:uint = readU16();
			var sign:int = val & 0x8000 ? -1 : 1;
			var exp:int = (val >> 10) & 0x1f;
			var fraction:Number = val & 0x3ff;
			if (exp == 0) {
				if (fraction == 0) {
					return 0;
				}
				else {
					return fraction;
				}
			}
			if (exp == 0x1f) {
				if (fraction == 0) {
					return Number.POSITIVE_INFINITY;
				}
				else {
					return Number.NaN;
				}
			}
			return sign * Math.pow(2, exp - 16) * (1 + fraction / 0x400);
		}
		
		public function readFloat():Number
		{
			return byteArray.readFloat();
		}
		
		public function readDouble():Number
		{
			return byteArray.readDouble();
		}
		
		public function readEncodedU32():uint
		{
			var result:uint = 0;
			var byte:uint = 0;
			var c:uint = 0;
			
			do {
				byte = readU8();
				result |= (byte & 0x7f) << (c++ * 7);
			}
			while (c < 5 && (byte & 0x80) != 0)
			
			return result;
		}
		
		public function readBit():Boolean
		{
			return readUBits(1) != 0;
		}
		
		public function readSBits(numBits:uint):int
		{
			var val:uint = readUBits(numBits);
			var shift:uint = 32 - numBits;
			var result:int = (val << shift) >> shift;
			return result;
		}
		
		public function readUBits(numBits:uint):uint
		{
			if (numBits == 0) {
				return 0;
			}
			
			if (_bitCursor == 0) {
				_bitBuffer = readU8();
				_bitCursor = 8;
			}
			
			var result:uint = 0;
			
			for (;;) {
				var s:int = numBits - _bitCursor;
				if (s > 0) {
					result |= _bitBuffer << s;
					numBits -= _bitCursor;
					_bitBuffer = readU8();
					_bitCursor = 8;
				}
				else {
					result |= _bitBuffer >> -s;
					_bitCursor -= numBits;
					_bitBuffer = _bitBuffer & (0xff >> (8 - _bitCursor))
					break;
				}
			}
			
			return result;
		}
		
		public function readFBits(numBits:uint):Number
		{
			return readSBits(numBits) / 65536;
		}
		
		public function resetBitCursor():void
		{
			_bitCursor = 0;
		}
		
		public function readUTF(length:uint = 0):String
		{
			if (length == 0) {
				var bytes:ByteArray = new ByteArray();
				var byte:uint;
				while ((byte = readU8()) != 0) {
					bytes.writeByte(byte);
				}
				bytes.position = 0;
				return bytes.readUTFBytes(bytes.length);
			}
			return byteArray.readUTFBytes(length);
		}
		
		public function readString(length:uint = 0, charset:String = 'iso-8859-1'):String
		{
			if (length == 0) {
				var bytes:ByteArray = new ByteArray();
				var byte:uint;
				while ((byte = readU8()) != 0) {
					bytes.writeByte(byte);
				}
				bytes.position = 0;
				return bytes.readMultiByte(bytes.length, charset);
			}
			return byteArray.readMultiByte(length, charset);
		}
		
		public function readBytes(dest:ByteArray, length:uint = 0):void
		{
			byteArray.readBytes(dest, 0, length);
		}
		
		public function uncompress(offset:uint = 0, length:uint = 0):void
		{
			var pos:uint = position;
			
			if (offset == 0 && length == 0) {
				byteArray.uncompress();
				seek(pos);
			}
			else {
				var temp:ByteArray = new ByteArray();
				temp.writeBytes(byteArray, offset, length);
				temp.uncompress();
				temp.position = temp.length - 1;
				if (length != 0 && (offset + length) < byteArray.length) {
					temp.writeBytes(byteArray, offset + length);
				}
				byteArray.length = offset;
				byteArray.position = offset;
				byteArray.writeBytes(temp);
				temp.length = 0;
			}
			
			seek(pos);
		}
		
		public function seek(position:int):void
		{
			if (position < 0) {
				this.position = 0;
			}
			else if (position < length) {
				this.position = position;
			}
			else {
				this.position = length - 1;
			}
		}
		
		public function skip(offset:int):void
		{
			position += offset;
		}
	}
}