unit md5;

interface

uses SysUtils, Classes;

type
  THashValue128 = array[0..15] of Byte;
  TMDRecord128 = packed record
    case Integer of
      0: (ByteValue: THashValue128);
      1: (LongValue: array[0..3] of LongWord);
  end;

  TMessageDigest = class
  private
    FState: TMDRecord128;
    FBuffer: array [0..63] of Byte;
    FBufSize: Integer;
  protected
    procedure Init; virtual; abstract;
    procedure Final(LastSize: Integer; Count: Int64); virtual; abstract;
    procedure Transform; virtual; abstract;
  public
    class function AsHex(const Value: THashValue128): string;
    function HashValue(const Src: string): THashValue128; overload;
    function HashValue(AStream: TStream;
        StartPos: Int64 = 0; Size: Int64 = 0): THashValue128; overload;
  end;

  TMessageDigest2 = class(TMessageDigest)
  private
    FX: array[0..47] of Byte;       // 384bit
    FCheckSum: THashValue128;
  protected
    procedure Init; override;
    procedure Final(LastSize: Integer; Count: Int64); override;
    procedure Transform; override;
  end;

  TMessageDigest4 = class(TMessageDigest)
  protected
    procedure Init; override;
    procedure Final(LastSize: Integer; Count: Int64); override;
    procedure Transform; override;
  end;

  TMessageDigest5 = class(TMessageDigest4)
  protected
    procedure Transform; override;
  public

  end;

implementation

{ TMessageDigest }

class function TMessageDigest.AsHex(const Value: THashValue128): string;
const
  HexDigits: array[0..15] of char = '0123456789ABCDEF';
var
  I: Integer;
begin
  SetLength(Result, 32);
  for I := 0 to 15 do
  begin
    Result[I shl 1 + 1] := HexDigits[Value[I] shr 4];
    Result[I shl 1 + 2] := HexDigits[Value[I] and $F];
  end;
end;

function TMessageDigest.HashValue(const Src: string): THashValue128;
var
  I, Len, Count: Integer;
begin
  Init;
  Count := Length(Src);
  Len := Count + 1;
  I := 1;
  while Len - I >= FBufSize do
  begin
    Move(Src[I], FBuffer, FBufSize);
    Transform;
    Inc(I, FBufSize);
  end;
  Dec(Len, I);
  if Len > 0 then
    Move(Src[I], FBuffer, Len);
  Final(Len, Count);
  Result := FState.ByteValue;
end;

function TMessageDigest.HashValue(AStream: TStream; StartPos, Size: Int64): THashValue128;
var
  Count: Int64;
begin
  if (StartPos >= 0) or (StartPos <= AStream.Size) then
    AStream.Position := StartPos;
  if (Size <= 0) or (Size > AStream.Size - AStream.Position) then
    Size := AStream.Size
  else Size := Size + AStream.Position;
  Count := Size - AStream.Position;
  Init;
  while Size - AStream.Position >= FBufSize do
  begin
    AStream.Read(FBuffer, FBufSize);
    Transform;
  end;
  Size := AStream.Read(FBuffer, Size - AStream.Position);
  FInal(Size, Count);
  Result := FState.ByteValue;
end;

const
  MD2_PI_SUBST : array [0..255] of byte = (
     41,  46,  67, 201, 162, 216, 124,   1,  61,  54,  84, 161, 236, 240,
      6,  19,  98, 167,   5, 243, 192, 199, 115, 140, 152, 147,  43, 217,
    188,  76, 130, 202,  30, 155,  87,  60, 253, 212, 224,  22, 103,  66,
    111,  24, 138,  23, 229,  18, 190,  78, 196, 214, 218, 158, 222,  73,
    160, 251, 245, 142, 187,  47, 238, 122, 169, 104, 121, 145,  21, 178,
      7,  63, 148, 194,  16, 137,  11,  34,  95,  33, 128, 127,  93, 154,
     90, 144,  50,  39,  53,  62, 204, 231, 191, 247, 151,   3, 255,  25,
     48, 179, 72, 165,  181, 209, 215,  94, 146,  42, 172,  86, 170, 198,
     79, 184,  56, 210, 150, 164, 125, 182, 118, 252, 107, 226, 156, 116,
      4, 241,  69, 157, 112,  89, 100, 113, 135,  32, 134,  91, 207, 101,
    230,  45, 168,   2,  27,  96,  37, 173, 174, 176, 185, 246,  28,  70,
     97, 105,  52,  64, 126, 15,   85,  71, 163,  35, 221,  81, 175,  58,
    195,  92, 249, 206, 186, 197, 234,  38,  44,  83,  13, 110, 133,  40,
    132,   9, 211, 223, 205, 244, 65,  129,  77,  82, 106, 220,  55, 200,
    108, 193, 171, 250,  36, 225, 123,   8,  12, 189, 177,  74, 120, 136,
    149, 139, 227,  99, 232, 109, 233, 203, 213, 254,  59,   0,  29,  57,
    242, 239, 183,  14, 102,  88, 208, 228, 166, 119, 114, 248, 235, 117,
     75,  10,  49,  68,  80, 180, 143, 237,  31,  26, 219, 153, 141,  51,
     159,  17, 131, 20);

{ TMessageDigest2 }

procedure TMessageDigest2.Final(LastSize: Integer; Count: Int64);
var
  Pad: Byte;
begin
  Pad := 16 - LastSize;
  // Step 1
  FillChar(FBuffer[LastSize], Pad, Pad);
  Transform;
  // Step 2
  Move(FCheckSum, FBuffer, 16);
  Transform;
  Move(FX, FState, 16);
end;

procedure TMessageDigest2.Init;
begin
  FBufSize := 16;
  FillChar(FCheckSum, 16, 0);
  FillChar(FBuffer, 16, 0);
  FillChar(FX, Sizeof(FX), 0);
end;

procedure TMessageDigest2.Transform;
const
  NumRounds = 18;
var
  x: Byte;
  i, j: Integer;
  T: Word;
  LCheckSumScore: Byte;
begin
  // Move the next 16 bytes into the second 16 bytes of X.
  for i := 0 to 15 do
  begin
    x := FBuffer[i];
    FX[i + 16] := x;
    FX[i + 32] := x xor FX[i];
  end;
  { Do 18 rounds. }
  T := 0;
  for i := 0 to NumRounds - 1 do
  begin
    for j := 0 to 47 do
    begin
      T := FX[j] xor MD2_PI_SUBST[T];
      FX[j] := T;// and $FF;
    end;
    T := (T + i) and $FF;
  end;

  LCheckSumScore := FChecksum[15];
  for i := 0 to 15 do
  begin
    x := FBuffer[i] xor LCheckSumScore;
    LCheckSumScore := FChecksum[i] xor MD2_PI_SUBST[x];
    FChecksum[i] := LCheckSumScore;
  end;
end;

{ TMessageDigest4 }

const
  MD4_INIT_VALUES: array[0..3] of LongWord = (
    $67452301, $EFCDAB89, $98BADCFE, $10325476);

function ROL(AVal: LongWord; AShift: Byte): LongWord;
asm
  mov   cl, dl
  rol   eax, cl
//   Result := (AVal shl AShift) or (AVal shr (32 - AShift));
end;

procedure TMessageDigest4.Final(LastSize: Integer; Count: Int64);
var
  I: Integer;
begin
  // Append one bit with value 1
  FBuffer[LastSize] := $80;
  Inc(LastSize);
  // Must have sufficient space to insert the 64-bit size value
  if LastSize > 56 then
  begin
    FillChar(FBuffer[LastSize], 64 - LastSize, 0);
    Transform;
    LastSize := 0;
  end;
  // Pad with zeroes. Leave room for the 64 bit size value.
  FillChar(FBuffer[LastSize], 56 - LastSize, 0);
  // Append the Number of bits processed.
  Count := Count shl 3;
  for I := 56 to 63 do
  begin
    FBuffer[I] := Count and $FF;
    Count := Count shr 8;
  end;
  Transform;
end;

procedure TMessageDigest4.Init;
begin
  FBufSize := 64;
  Move(MD4_INIT_VALUES, FState, 16);
end;

procedure TMessageDigest4.Transform;
var
  A, B, C, D, i : LongWord;
  buff : array[0..15] of LongWord; // 64-byte buffer
begin
  A := FState.LongValue[0];
  B := FState.LongValue[1];
  C := FState.LongValue[2];
  D := FState.LongValue[3];
  Move(FBuffer, buff, Sizeof(buff));
  // Round 1
  for i := 0 to 3 do
  begin
    A := ROL((((D xor C) and B) xor D) + A + buff[i*4+0],  3);
    D := ROL((((C xor B) and A) xor C) + D + buff[i*4+1],  7);
    C := ROL((((B xor A) and D) xor B) + C + buff[i*4+2], 11);
    B := ROL((((A xor D) and C) xor A) + B + buff[i*4+3], 19);
  end;
  // Round 2
  for i := 0 to 3 do
  begin
    A := ROL(((B and C) or (D and (B or C))) + A + buff[0*4+i] + $5A827999,  3);
    D := ROL(((A and B) or (C and (A or B))) + D + buff[1*4+i] + $5A827999,  5);
    C := ROL(((D and A) or (B and (D or A))) + C + buff[2*4+i] + $5A827999,  9);
    B := ROL(((C and D) or (A and (C or D))) + B + buff[3*4+i] + $5A827999, 13);
  end;
  // Round 3
  A := ROL((B xor C xor D) + A + buff[ 0] + $6ED9EBA1,  3);
  D := ROL((A xor B xor C) + D + buff[ 8] + $6ED9EBA1,  9);
  C := ROL((D xor A xor B) + C + buff[ 4] + $6ED9EBA1, 11);
  B := ROL((C xor D xor A) + B + buff[12] + $6ED9EBA1, 15);
  A := ROL((B xor C xor D) + A + buff[ 2] + $6ED9EBA1,  3);
  D := ROL((A xor B xor C) + D + buff[10] + $6ED9EBA1,  9);
  C := ROL((D xor A xor B) + C + buff[ 6] + $6ED9EBA1, 11);
  B := ROL((C xor D xor A) + B + buff[14] + $6ED9EBA1, 15);
  A := ROL((B xor C xor D) + A + buff[ 1] + $6ED9EBA1,  3);
  D := ROL((A xor B xor C) + D + buff[ 9] + $6ED9EBA1,  9);
  C := ROL((D xor A xor B) + C + buff[ 5] + $6ED9EBA1, 11);
  B := ROL((C xor D xor A) + B + buff[13] + $6ED9EBA1, 15);
  A := ROL((B xor C xor D) + A + buff[ 3] + $6ED9EBA1,  3);
  D := ROL((A xor B xor C) + D + buff[11] + $6ED9EBA1,  9);
  C := ROL((D xor A xor B) + C + buff[ 7] + $6ED9EBA1, 11);
  B := ROL((C xor D xor A) + B + buff[15] + $6ED9EBA1, 15);

  Inc(FState.LongValue[0], A);
  Inc(FState.LongValue[1], B);
  Inc(FState.LongValue[2], C);
  Inc(FState.LongValue[3], D);
end;

{ TMessageDigest5 }

const
  MD5_SINE : array [1..64] of LongWord = (
   { Round 1. }
   $d76aa478, $e8c7b756, $242070db, $c1bdceee, $f57c0faf, $4787c62a,
   $a8304613, $fd469501, $698098d8, $8b44f7af, $ffff5bb1, $895cd7be,
   $6b901122, $fd987193, $a679438e, $49b40821,
   { Round 2. }
   $f61e2562, $c040b340, $265e5a51, $e9b6c7aa, $d62f105d, $02441453,
   $d8a1e681, $e7d3fbc8, $21e1cde6, $c33707d6, $f4d50d87, $455a14ed,
   $a9e3e905, $fcefa3f8, $676f02d9, $8d2a4c8a,
   { Round 3. }
   $fffa3942, $8771f681, $6d9d6122, $fde5380c, $a4beea44, $4bdecfa9,
   $f6bb4b60, $bebfbc70, $289b7ec6, $eaa127fa, $d4ef3085, $04881d05,
   $d9d4d039, $e6db99e5, $1fa27cf8, $c4ac5665,
   { Round 4. }
   $f4292244, $432aff97, $ab9423a7, $fc93a039, $655b59c3, $8f0ccc92,
   $ffeff47d, $85845dd1, $6fa87e4f, $fe2ce6e0, $a3014314, $4e0811a1,
   $f7537e82, $bd3af235, $2ad7d2bb, $eb86d391
  );

procedure TMessageDigest5.Transform;
var
  A, B, C, D: LongWord;
  x : array[0..15] of LongWord; // 64-byte buffer
begin
  A := FState.LongValue[0];
  B := FState.LongValue[1];
  C := FState.LongValue[2];
  D := FState.LongValue[3];
  Move(FBuffer, x, Sizeof(x));
{ Round 1 }
  A := ROL(A + (((D xor C) and B) xor D) + x[ 0] + MD5_SINE[ 1],  7) + B;
  D := ROL(D + (((C xor B) and A) xor C) + x[ 1] + MD5_SINE[ 2], 12) + A;
  C := ROL(C + (((B xor A) and D) xor B) + x[ 2] + MD5_SINE[ 3], 17) + D;
  B := ROL(B + (((A xor D) and C) xor A) + x[ 3] + MD5_SINE[ 4], 22) + C;
  A := ROL(A + (((D xor C) and B) xor D) + x[ 4] + MD5_SINE[ 5],  7) + B;
  D := ROL(D + (((C xor B) and A) xor C) + x[ 5] + MD5_SINE[ 6], 12) + A;
  C := ROL(C + (((B xor A) and D) xor B) + x[ 6] + MD5_SINE[ 7], 17) + D;
  B := ROL(B + (((A xor D) and C) xor A) + x[ 7] + MD5_SINE[ 8], 22) + C;
  A := ROL(A + (((D xor C) and B) xor D) + x[ 8] + MD5_SINE[ 9],  7) + B;
  D := ROL(D + (((C xor B) and A) xor C) + x[ 9] + MD5_SINE[10], 12) + A;
  C := ROL(C + (((B xor A) and D) xor B) + x[10] + MD5_SINE[11], 17) + D;
  B := ROL(B + (((A xor D) and C) xor A) + x[11] + MD5_SINE[12], 22) + C;
  A := ROL(A + (((D xor C) and B) xor D) + x[12] + MD5_SINE[13],  7) + B;
  D := ROL(D + (((C xor B) and A) xor C) + x[13] + MD5_SINE[14], 12) + A;
  C := ROL(C + (((B xor A) and D) xor B) + x[14] + MD5_SINE[15], 17) + D;
  B := ROL(B + (((A xor D) and C) xor A) + x[15] + MD5_SINE[16], 22) + C;
  { Round 2 }
  A := ROL(A + (C xor (D and (B xor C))) + x[ 1] + MD5_SINE[17],  5) + B;
  D := ROL(D + (B xor (C and (A xor B))) + x[ 6] + MD5_SINE[18],  9) + A;
  C := ROL(C + (A xor (B and (D xor A))) + x[11] + MD5_SINE[19], 14) + D;
  B := ROL(B + (D xor (A and (C xor D))) + x[ 0] + MD5_SINE[20], 20) + C;
  A := ROL(A + (C xor (D and (B xor C))) + x[ 5] + MD5_SINE[21],  5) + B;
  D := ROL(D + (B xor (C and (A xor B))) + x[10] + MD5_SINE[22],  9) + A;
  C := ROL(C + (A xor (B and (D xor A))) + x[15] + MD5_SINE[23], 14) + D;
  B := ROL(B + (D xor (A and (C xor D))) + x[ 4] + MD5_SINE[24], 20) + C;
  A := ROL(A + (C xor (D and (B xor C))) + x[ 9] + MD5_SINE[25],  5) + B;
  D := ROL(D + (B xor (C and (A xor B))) + x[14] + MD5_SINE[26],  9) + A;
  C := ROL(C + (A xor (B and (D xor A))) + x[ 3] + MD5_SINE[27], 14) + D;
  B := ROL(B + (D xor (A and (C xor D))) + x[ 8] + MD5_SINE[28], 20) + C;
  A := ROL(A + (C xor (D and (B xor C))) + x[13] + MD5_SINE[29],  5) + B;
  D := ROL(D + (B xor (C and (A xor B))) + x[ 2] + MD5_SINE[30],  9) + A;
  C := ROL(C + (A xor (B and (D xor A))) + x[ 7] + MD5_SINE[31], 14) + D;
  B := ROL(B + (D xor (A and (C xor D))) + x[12] + MD5_SINE[32], 20) + C;
  { Round 3. }
  A := ROL(A + (B xor C xor D) + x[ 5] + MD5_SINE[33],  4) + B;
  D := ROL(D + (A xor B xor C) + x[ 8] + MD5_SINE[34], 11) + A;
  C := ROL(C + (D xor A xor B) + x[11] + MD5_SINE[35], 16) + D;
  B := ROL(B + (C xor D xor A) + x[14] + MD5_SINE[36], 23) + C;
  A := ROL(A + (B xor C xor D) + x[ 1] + MD5_SINE[37],  4) + B;
  D := ROL(D + (A xor B xor C) + x[ 4] + MD5_SINE[38], 11) + A;
  C := ROL(C + (D xor A xor B) + x[ 7] + MD5_SINE[39], 16) + D;
  B := ROL(B + (C xor D xor A) + x[10] + MD5_SINE[40], 23) + C;
  A := ROL(A + (B xor C xor D) + x[13] + MD5_SINE[41],  4) + B;
  D := ROL(D + (A xor B xor C) + x[ 0] + MD5_SINE[42], 11) + A;
  C := ROL(C + (D xor A xor B) + x[ 3] + MD5_SINE[43], 16) + D;
  B := ROL(B + (C xor D xor A) + x[ 6] + MD5_SINE[44], 23) + C;
  A := ROL(A + (B xor C xor D) + x[ 9] + MD5_SINE[45],  4) + B;
  D := ROL(D + (A xor B xor C) + x[12] + MD5_SINE[46], 11) + A;
  C := ROL(C + (D xor A xor B) + x[15] + MD5_SINE[47], 16) + D;
  B := ROL(B + (C xor D xor A) + x[ 2] + MD5_SINE[48], 23) + C;
  { Round 4. }
  A := ROL(A + ((B or not D) xor C) + x[ 0] + MD5_SINE[49],  6) + B;
  D := ROL(D + ((A or not C) xor B) + x[ 7] + MD5_SINE[50], 10) + A;
  C := ROL(C + ((D or not B) xor A) + x[14] + MD5_SINE[51], 15) + D;
  B := ROL(B + ((C or not A) xor D) + x[ 5] + MD5_SINE[52], 21) + C;
  A := ROL(A + ((B or not D) xor C) + x[12] + MD5_SINE[53],  6) + B;
  D := ROL(D + ((A or not C) xor B) + x[ 3] + MD5_SINE[54], 10) + A;
  C := ROL(C + ((D or not B) xor A) + x[10] + MD5_SINE[55], 15) + D;
  B := ROL(B + ((C or not A) xor D) + x[ 1] + MD5_SINE[56], 21) + C;
  A := ROL(A + ((B or not D) xor C) + x[ 8] + MD5_SINE[57],  6) + B;
  D := ROL(D + ((A or not C) xor B) + x[15] + MD5_SINE[58], 10) + A;
  C := ROL(C + ((D or not B) xor A) + x[ 6] + MD5_SINE[59], 15) + D;
  B := ROL(B + ((C or not A) xor D) + x[13] + MD5_SINE[60], 21) + C;
  A := ROL(A + ((B or not D) xor C) + x[ 4] + MD5_SINE[61],  6) + B;
  D := ROL(D + ((A or not C) xor B) + x[11] + MD5_SINE[62], 10) + A;
  C := ROL(C + ((D or not B) xor A) + x[ 2] + MD5_SINE[63], 15) + D;
  B := ROL(B + ((C or not A) xor D) + x[ 9] + MD5_SINE[64], 21) + C;

  Inc(FState.LongValue[0], A);
  Inc(FState.LongValue[1], B);
  Inc(FState.LongValue[2], C);
  Inc(FState.LongValue[3], D);
end;

end.
