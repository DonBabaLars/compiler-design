; generated from: oatprograms/run33.oat
target triple = "x86_64-unknown-linux"
define i64 @program(i64 %_argc4, { i64, [0 x i8*] }* %_argv1) {
  %_b13 = alloca { i64, [0 x i1] }*
  %_i15 = alloca i64
  %_raw_array7 = call i64* @oat_alloc_array(i64 2)
  %_array8 = bitcast i64* %_raw_array7 to { i64, [0 x i1] }*
  %_ind9 = getelementptr { i64, [0 x i1] }, { i64, [0 x i1] }* %_array8, i32 0, i32 1, i32 0
  store i1 1, i1* %_ind9
  %_ind11 = getelementptr { i64, [0 x i1] }, { i64, [0 x i1] }* %_array8, i32 0, i32 1, i32 1
  store i1 0, i1* %_ind11
  store { i64, [0 x i1] }* %_array8, { i64, [0 x i1] }** %_b13
  store i64 0, i64* %_i15
  %_b17 = load { i64, [0 x i1] }*, { i64, [0 x i1] }** %_b13
  %_tmp19 = bitcast { i64, [0 x i1] }* %_b17 to i64*
  call void @oat_assert_array_length(i64* %_tmp19, i64 0)
  %_index_ptr20 = getelementptr { i64, [0 x i1] }, { i64, [0 x i1] }* %_b17, i32 0, i32 1, i32 0
  %_index21 = load i1, i1* %_index_ptr20
  br i1 %_index21, label %_then25, label %_else24
_else24:
  br label %_merge23
_merge23:
  %_i26 = load i64, i64* %_i15
  ret i64 %_i26
_then25:
  store i64 1, i64* %_i15
  br label %_merge23
}


declare i64* @oat_malloc(i64)
declare i64* @oat_alloc_array(i64)
declare void @oat_assert_not_null(i8*)
declare void @oat_assert_array_length(i64*, i64)
declare { i64, [0 x i64] }* @array_of_string(i8*)
declare i8* @string_of_array({ i64, [0 x i64] }*)
declare i64 @length_of_string(i8*)
declare i8* @string_of_int(i64)
declare i8* @string_cat(i8*, i8*)
declare void @print_string(i8*)
declare void @print_int(i64)
declare void @print_bool(i1)
