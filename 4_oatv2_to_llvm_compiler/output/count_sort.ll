; generated from: oatprograms/count_sort.oat
target triple = "x86_64-unknown-linux"
@_str_arr21 = global [2 x i8] c"
\00"

define i64 @min({ i64, [0 x i64] }* %_arr199, i64 %_len197) {
  %_arr200 = alloca { i64, [0 x i64] }*
  %_len198 = alloca i64
  %_min205 = alloca i64
  %_i206 = alloca i64
  store { i64, [0 x i64] }* %_arr199, { i64, [0 x i64] }** %_arr200
  store i64 %_len197, i64* %_len198
  %_arr201 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr200
  %_index_ptr203 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr201, i32 0, i32 1, i32 0
  %_index204 = load i64, i64* %_index_ptr203
  store i64 %_index204, i64* %_min205
  store i64 0, i64* %_i206
  br label %_cond212
_cond212:
  %_i207 = load i64, i64* %_i206
  %_len208 = load i64, i64* %_len198
  %_bop209 = icmp slt i64 %_i207, %_len208
  br i1 %_bop209, label %_body211, label %_post210
_body211:
  %_arr213 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr200
  %_i214 = load i64, i64* %_i206
  %_index_ptr216 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr213, i32 0, i32 1, i64 %_i214
  %_index217 = load i64, i64* %_index_ptr216
  %_min218 = load i64, i64* %_min205
  %_bop219 = icmp slt i64 %_index217, %_min218
  br i1 %_bop219, label %_then227, label %_else226
_then227:
  %_arr220 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr200
  %_i221 = load i64, i64* %_i206
  %_index_ptr223 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr220, i32 0, i32 1, i64 %_i221
  %_index224 = load i64, i64* %_index_ptr223
  store i64 %_index224, i64* %_min205
  br label %_merge225
_else226:
  br label %_merge225
_merge225:
  %_i228 = load i64, i64* %_i206
  %_bop229 = add i64 %_i228, 1
  store i64 %_bop229, i64* %_i206
  br label %_cond212
_post210:
  %_min230 = load i64, i64* %_min205
  ret i64 %_min230
}

define i64 @max({ i64, [0 x i64] }* %_arr165, i64 %_len163) {
  %_arr166 = alloca { i64, [0 x i64] }*
  %_len164 = alloca i64
  %_max171 = alloca i64
  %_i172 = alloca i64
  store { i64, [0 x i64] }* %_arr165, { i64, [0 x i64] }** %_arr166
  store i64 %_len163, i64* %_len164
  %_arr167 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr166
  %_index_ptr169 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr167, i32 0, i32 1, i32 0
  %_index170 = load i64, i64* %_index_ptr169
  store i64 %_index170, i64* %_max171
  store i64 0, i64* %_i172
  br label %_cond178
_cond178:
  %_i173 = load i64, i64* %_i172
  %_len174 = load i64, i64* %_len164
  %_bop175 = icmp slt i64 %_i173, %_len174
  br i1 %_bop175, label %_body177, label %_post176
_body177:
  %_arr179 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr166
  %_i180 = load i64, i64* %_i172
  %_index_ptr182 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr179, i32 0, i32 1, i64 %_i180
  %_index183 = load i64, i64* %_index_ptr182
  %_max184 = load i64, i64* %_max171
  %_bop185 = icmp sgt i64 %_index183, %_max184
  br i1 %_bop185, label %_then193, label %_else192
_then193:
  %_arr186 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr166
  %_i187 = load i64, i64* %_i172
  %_index_ptr189 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr186, i32 0, i32 1, i64 %_i187
  %_index190 = load i64, i64* %_index_ptr189
  store i64 %_index190, i64* %_max171
  br label %_merge191
_else192:
  br label %_merge191
_merge191:
  %_i194 = load i64, i64* %_i172
  %_bop195 = add i64 %_i194, 1
  store i64 %_bop195, i64* %_i172
  br label %_cond178
_post176:
  %_max196 = load i64, i64* %_max171
  ret i64 %_max196
}

define { i64, [0 x i64] }* @count_sort({ i64, [0 x i64] }* %_arr33, i64 %_len31) {
  %_arr34 = alloca { i64, [0 x i64] }*
  %_len32 = alloca i64
  %_min38 = alloca i64
  %_max42 = alloca i64
  %_i53 = alloca i64
  %_counts66 = alloca { i64, [0 x i64] }*
  %_i67 = alloca i64
  %_i99 = alloca i64
  %_j100 = alloca i64
  %_i2108 = alloca i64
  %_out121 = alloca { i64, [0 x i64] }*
  store { i64, [0 x i64] }* %_arr33, { i64, [0 x i64] }** %_arr34
  store i64 %_len31, i64* %_len32
  %_len35 = load i64, i64* %_len32
  %_arr36 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr34
  %_result37 = call i64 @min({ i64, [0 x i64] }* %_arr36, i64 %_len35)
  store i64 %_result37, i64* %_min38
  %_len39 = load i64, i64* %_len32
  %_arr40 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr34
  %_result41 = call i64 @max({ i64, [0 x i64] }* %_arr40, i64 %_len39)
  store i64 %_result41, i64* %_max42
  %_max43 = load i64, i64* %_max42
  %_min44 = load i64, i64* %_min38
  %_bop45 = sub i64 %_max43, %_min44
  %_bop46 = add i64 %_bop45, 1
  %_raw_array47 = call i64* @oat_alloc_array(i64 %_bop46)
  %_array48 = bitcast i64* %_raw_array47 to { i64, [0 x i64] }*
  %_new_array_ptr50 = alloca { i64, [0 x i64] }*
  store { i64, [0 x i64] }* %_array48, { i64, [0 x i64] }** %_new_array_ptr50
  %_length_ptr52 = alloca i64
  store i64 %_bop46, i64* %_length_ptr52
  store i64 0, i64* %_i53
  br label %_cond59
_cond59:
  %_i54 = load i64, i64* %_i53
  %__loop_length5155 = load i64, i64* %_length_ptr52
  %_bop56 = icmp slt i64 %_i54, %__loop_length5155
  br i1 %_bop56, label %_body58, label %_post57
_body58:
  %__temp_array4960 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_new_array_ptr50
  %_i61 = load i64, i64* %_i53
  %_index_ptr63 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %__temp_array4960, i32 0, i32 1, i64 %_i61
  store i64 0, i64* %_index_ptr63
  %_i64 = load i64, i64* %_i53
  %_bop65 = add i64 %_i64, 1
  store i64 %_bop65, i64* %_i53
  br label %_cond59
_post57:
  store { i64, [0 x i64] }* %_array48, { i64, [0 x i64] }** %_counts66
  store i64 0, i64* %_i67
  br label %_cond73
_cond73:
  %_i68 = load i64, i64* %_i67
  %_len69 = load i64, i64* %_len32
  %_bop70 = icmp slt i64 %_i68, %_len69
  br i1 %_bop70, label %_body72, label %_post71
_body72:
  %_counts74 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_counts66
  %_arr75 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr34
  %_i76 = load i64, i64* %_i67
  %_index_ptr78 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr75, i32 0, i32 1, i64 %_i76
  %_index79 = load i64, i64* %_index_ptr78
  %_min80 = load i64, i64* %_min38
  %_bop81 = sub i64 %_index79, %_min80
  %_index_ptr83 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_counts74, i32 0, i32 1, i64 %_bop81
  %_counts84 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_counts66
  %_arr85 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr34
  %_i86 = load i64, i64* %_i67
  %_index_ptr88 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_arr85, i32 0, i32 1, i64 %_i86
  %_index89 = load i64, i64* %_index_ptr88
  %_min90 = load i64, i64* %_min38
  %_bop91 = sub i64 %_index89, %_min90
  %_index_ptr93 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_counts84, i32 0, i32 1, i64 %_bop91
  %_index94 = load i64, i64* %_index_ptr93
  %_bop95 = add i64 %_index94, 1
  store i64 %_bop95, i64* %_index_ptr83
  %_i96 = load i64, i64* %_i67
  %_bop97 = add i64 %_i96, 1
  store i64 %_bop97, i64* %_i67
  br label %_cond73
_post71:
  %_min98 = load i64, i64* %_min38
  store i64 %_min98, i64* %_i99
  store i64 0, i64* %_j100
  %_len101 = load i64, i64* %_len32
  %_raw_array102 = call i64* @oat_alloc_array(i64 %_len101)
  %_array103 = bitcast i64* %_raw_array102 to { i64, [0 x i64] }*
  %_new_array_ptr105 = alloca { i64, [0 x i64] }*
  store { i64, [0 x i64] }* %_array103, { i64, [0 x i64] }** %_new_array_ptr105
  %_length_ptr107 = alloca i64
  store i64 %_len101, i64* %_length_ptr107
  store i64 0, i64* %_i2108
  br label %_cond114
_cond114:
  %_i2109 = load i64, i64* %_i2108
  %__loop_length106110 = load i64, i64* %_length_ptr107
  %_bop111 = icmp slt i64 %_i2109, %__loop_length106110
  br i1 %_bop111, label %_body113, label %_post112
_body113:
  %__temp_array104115 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_new_array_ptr105
  %_i2116 = load i64, i64* %_i2108
  %_index_ptr118 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %__temp_array104115, i32 0, i32 1, i64 %_i2116
  store i64 0, i64* %_index_ptr118
  %_i2119 = load i64, i64* %_i2108
  %_bop120 = add i64 %_i2119, 1
  store i64 %_bop120, i64* %_i2108
  br label %_cond114
_post112:
  store { i64, [0 x i64] }* %_array103, { i64, [0 x i64] }** %_out121
  br label %_cond127
_cond127:
  %_i122 = load i64, i64* %_i99
  %_max123 = load i64, i64* %_max42
  %_bop124 = icmp sle i64 %_i122, %_max123
  br i1 %_bop124, label %_body126, label %_post125
_body126:
  %_counts128 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_counts66
  %_i129 = load i64, i64* %_i99
  %_min130 = load i64, i64* %_min38
  %_bop131 = sub i64 %_i129, %_min130
  %_index_ptr133 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_counts128, i32 0, i32 1, i64 %_bop131
  %_index134 = load i64, i64* %_index_ptr133
  %_bop135 = icmp sgt i64 %_index134, 0
  br i1 %_bop135, label %_then161, label %_else160
_then161:
  %_out136 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_out121
  %_j137 = load i64, i64* %_j100
  %_index_ptr139 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_out136, i32 0, i32 1, i64 %_j137
  %_i140 = load i64, i64* %_i99
  store i64 %_i140, i64* %_index_ptr139
  %_counts141 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_counts66
  %_i142 = load i64, i64* %_i99
  %_min143 = load i64, i64* %_min38
  %_bop144 = sub i64 %_i142, %_min143
  %_index_ptr146 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_counts141, i32 0, i32 1, i64 %_bop144
  %_counts147 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_counts66
  %_i148 = load i64, i64* %_i99
  %_min149 = load i64, i64* %_min38
  %_bop150 = sub i64 %_i148, %_min149
  %_index_ptr152 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_counts147, i32 0, i32 1, i64 %_bop150
  %_index153 = load i64, i64* %_index_ptr152
  %_bop154 = sub i64 %_index153, 1
  store i64 %_bop154, i64* %_index_ptr146
  %_j155 = load i64, i64* %_j100
  %_bop156 = add i64 %_j155, 1
  store i64 %_bop156, i64* %_j100
  br label %_merge159
_else160:
  %_i157 = load i64, i64* %_i99
  %_bop158 = add i64 %_i157, 1
  store i64 %_bop158, i64* %_i99
  br label %_merge159
_merge159:
  br label %_cond127
_post125:
  %_out162 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_out121
  ret { i64, [0 x i64] }* %_out162
}

define i64 @program(i64 %_argc3, { i64, [0 x i8*] }* %_argv1) {
  %_argc4 = alloca i64
  %_argv2 = alloca { i64, [0 x i8*] }*
  %_arr16 = alloca { i64, [0 x i64] }*
  %_len17 = alloca i64
  %_sorted27 = alloca { i64, [0 x i64] }*
  store i64 %_argc3, i64* %_argc4
  store { i64, [0 x i8*] }* %_argv1, { i64, [0 x i8*] }** %_argv2
  %_raw_array5 = call i64* @oat_alloc_array(i64 9)
  %_array6 = bitcast i64* %_raw_array5 to { i64, [0 x i64] }*
  %_ind7 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 0
  store i64 65, i64* %_ind7
  %_ind8 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 1
  store i64 70, i64* %_ind8
  %_ind9 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 2
  store i64 72, i64* %_ind9
  %_ind10 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 3
  store i64 90, i64* %_ind10
  %_ind11 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 4
  store i64 65, i64* %_ind11
  %_ind12 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 5
  store i64 65, i64* %_ind12
  %_ind13 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 6
  store i64 69, i64* %_ind13
  %_ind14 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 7
  store i64 89, i64* %_ind14
  %_ind15 = getelementptr { i64, [0 x i64] }, { i64, [0 x i64] }* %_array6, i32 0, i32 1, i32 8
  store i64 67, i64* %_ind15
  store { i64, [0 x i64] }* %_array6, { i64, [0 x i64] }** %_arr16
  store i64 9, i64* %_len17
  %_arr18 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr16
  %_result19 = call i8* @string_of_array({ i64, [0 x i64] }* %_arr18)
  call void @print_string(i8* %_result19)
  %_str22 = getelementptr [2 x i8], [2 x i8]* @_str_arr21, i32 0, i32 0
  call void @print_string(i8* %_str22)
  %_len24 = load i64, i64* %_len17
  %_arr25 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_arr16
  %_result26 = call { i64, [0 x i64] }* @count_sort({ i64, [0 x i64] }* %_arr25, i64 %_len24)
  store { i64, [0 x i64] }* %_result26, { i64, [0 x i64] }** %_sorted27
  %_sorted28 = load { i64, [0 x i64] }*, { i64, [0 x i64] }** %_sorted27
  %_result29 = call i8* @string_of_array({ i64, [0 x i64] }* %_sorted28)
  call void @print_string(i8* %_result29)
  ret i64 0
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
