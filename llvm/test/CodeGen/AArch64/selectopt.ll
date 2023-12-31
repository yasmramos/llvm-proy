; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -select-optimize -mtriple=aarch64-linux-gnu -mcpu=generic -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -select-optimize -mtriple=aarch64-linux-gnu -mcpu=cortex-a55 -S < %s | FileCheck %s --check-prefix=CHECKII
; RUN: opt -select-optimize -mtriple=aarch64-linux-gnu -mcpu=cortex-a510 -S < %s | FileCheck %s --check-prefix=CHECKII
; RUN: opt -select-optimize -mtriple=aarch64-linux-gnu -mcpu=cortex-a72 -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -select-optimize -mtriple=aarch64-linux-gnu -mcpu=neoverse-n1 -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -select-optimize -mtriple=aarch64-linux-gnu -mcpu=cortex-a710 -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -select-optimize -mtriple=aarch64-linux-gnu -mcpu=neoverse-v2 -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -passes='require<profile-summary>,function(select-optimize)' -mtriple=aarch64-linux-gnu -mcpu=generic -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -passes='require<profile-summary>,function(select-optimize)' -mtriple=aarch64-linux-gnu -mcpu=cortex-a55 -S < %s | FileCheck %s --check-prefix=CHECKII
; RUN: opt -passes='require<profile-summary>,function(select-optimize)' -mtriple=aarch64-linux-gnu -mcpu=cortex-a510 -S < %s | FileCheck %s --check-prefix=CHECKII
; RUN: opt -passes='require<profile-summary>,function(select-optimize)' -mtriple=aarch64-linux-gnu -mcpu=cortex-a72 -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -passes='require<profile-summary>,function(select-optimize)' -mtriple=aarch64-linux-gnu -mcpu=neoverse-n1 -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -passes='require<profile-summary>,function(select-optimize)' -mtriple=aarch64-linux-gnu -mcpu=cortex-a710 -S < %s | FileCheck %s --check-prefix=CHECKOO
; RUN: opt -passes='require<profile-summary>,function(select-optimize)' -mtriple=aarch64-linux-gnu -mcpu=neoverse-v2 -S < %s | FileCheck %s --check-prefix=CHECKOO

%struct.st = type { i32, i64, ptr, ptr, i16, ptr, ptr, i64, i64 }

; This test has a select at the end of if.then, which is better transformed to a branch on OoO cores.

define void @replace(ptr nocapture noundef %newst, ptr noundef %t, ptr noundef %h, i64 noundef %c, i64 noundef %rc, i64 noundef %ma, i64 noundef %n) {
; CHECKOO-LABEL: @replace(
; CHECKOO-NEXT:  entry:
; CHECKOO-NEXT:    [[T1:%.*]] = getelementptr inbounds [[STRUCT_ST:%.*]], ptr [[NEWST:%.*]], i64 0, i32 2
; CHECKOO-NEXT:    store ptr [[T:%.*]], ptr [[T1]], align 8
; CHECKOO-NEXT:    [[H3:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 3
; CHECKOO-NEXT:    store ptr [[H:%.*]], ptr [[H3]], align 8
; CHECKOO-NEXT:    [[ORG_C:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 8
; CHECKOO-NEXT:    store i64 [[C:%.*]], ptr [[ORG_C]], align 8
; CHECKOO-NEXT:    [[C6:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 1
; CHECKOO-NEXT:    store i64 [[C]], ptr [[C6]], align 8
; CHECKOO-NEXT:    [[FLOW:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 7
; CHECKOO-NEXT:    store i64 [[RC:%.*]], ptr [[FLOW]], align 8
; CHECKOO-NEXT:    [[CONV:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECKOO-NEXT:    store i32 [[CONV]], ptr [[NEWST]], align 8
; CHECKOO-NEXT:    [[FLOW10:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 1, i32 7
; CHECKOO-NEXT:    [[TMP0:%.*]] = load i64, ptr [[FLOW10]], align 8
; CHECKOO-NEXT:    [[FLOW12:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 2, i32 7
; CHECKOO-NEXT:    [[TMP1:%.*]] = load i64, ptr [[FLOW12]], align 8
; CHECKOO-NEXT:    [[CMP13:%.*]] = icmp sgt i64 [[TMP0]], [[TMP1]]
; CHECKOO-NEXT:    [[CONV15:%.*]] = select i1 [[CMP13]], i64 2, i64 3
; CHECKOO-NEXT:    [[CMP16_NOT149:%.*]] = icmp sgt i64 [[CONV15]], [[MA:%.*]]
; CHECKOO-NEXT:    br i1 [[CMP16_NOT149]], label [[WHILE_END:%.*]], label [[LAND_RHS:%.*]]
; CHECKOO:       land.rhs:
; CHECKOO-NEXT:    [[CMP_0151:%.*]] = phi i64 [ [[CMP_1:%.*]], [[IF_END87:%.*]] ], [ [[CONV15]], [[ENTRY:%.*]] ]
; CHECKOO-NEXT:    [[POS_0150:%.*]] = phi i64 [ [[CMP_0151]], [[IF_END87]] ], [ 1, [[ENTRY]] ]
; CHECKOO-NEXT:    [[SUB:%.*]] = add nsw i64 [[CMP_0151]], -1
; CHECKOO-NEXT:    [[FLOW19:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 7
; CHECKOO-NEXT:    [[TMP2:%.*]] = load i64, ptr [[FLOW19]], align 8
; CHECKOO-NEXT:    [[CMP20:%.*]] = icmp sgt i64 [[TMP2]], [[RC]]
; CHECKOO-NEXT:    br i1 [[CMP20]], label [[WHILE_BODY:%.*]], label [[WHILE_END]]
; CHECKOO:       while.body:
; CHECKOO-NEXT:    [[ARRAYIDX18:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]]
; CHECKOO-NEXT:    [[T24:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 2
; CHECKOO-NEXT:    [[TMP3:%.*]] = load ptr, ptr [[T24]], align 8
; CHECKOO-NEXT:    [[SUB25:%.*]] = add nsw i64 [[POS_0150]], -1
; CHECKOO-NEXT:    [[ARRAYIDX26:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]]
; CHECKOO-NEXT:    [[T27:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 2
; CHECKOO-NEXT:    store ptr [[TMP3]], ptr [[T27]], align 8
; CHECKOO-NEXT:    [[H30:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 3
; CHECKOO-NEXT:    [[TMP4:%.*]] = load ptr, ptr [[H30]], align 8
; CHECKOO-NEXT:    [[H33:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 3
; CHECKOO-NEXT:    store ptr [[TMP4]], ptr [[H33]], align 8
; CHECKOO-NEXT:    [[C36:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 1
; CHECKOO-NEXT:    [[TMP5:%.*]] = load i64, ptr [[C36]], align 8
; CHECKOO-NEXT:    [[C39:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 1
; CHECKOO-NEXT:    store i64 [[TMP5]], ptr [[C39]], align 8
; CHECKOO-NEXT:    [[TMP6:%.*]] = load i64, ptr [[C36]], align 8
; CHECKOO-NEXT:    [[ORG_C45:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 8
; CHECKOO-NEXT:    store i64 [[TMP6]], ptr [[ORG_C45]], align 8
; CHECKOO-NEXT:    [[FLOW51:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 7
; CHECKOO-NEXT:    store i64 [[TMP2]], ptr [[FLOW51]], align 8
; CHECKOO-NEXT:    [[TMP7:%.*]] = load i32, ptr [[ARRAYIDX18]], align 8
; CHECKOO-NEXT:    store i32 [[TMP7]], ptr [[ARRAYIDX26]], align 8
; CHECKOO-NEXT:    store ptr [[T]], ptr [[T24]], align 8
; CHECKOO-NEXT:    store ptr [[H]], ptr [[H30]], align 8
; CHECKOO-NEXT:    store i64 [[C]], ptr [[C36]], align 8
; CHECKOO-NEXT:    [[ORG_C69:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 8
; CHECKOO-NEXT:    store i64 [[C]], ptr [[ORG_C69]], align 8
; CHECKOO-NEXT:    store i64 [[RC]], ptr [[FLOW19]], align 8
; CHECKOO-NEXT:    store i32 [[CONV]], ptr [[ARRAYIDX18]], align 8
; CHECKOO-NEXT:    [[MUL:%.*]] = shl nsw i64 [[CMP_0151]], 1
; CHECKOO-NEXT:    [[ADD:%.*]] = or i64 [[MUL]], 1
; CHECKOO-NEXT:    [[CMP77_NOT:%.*]] = icmp sgt i64 [[ADD]], [[MA]]
; CHECKOO-NEXT:    br i1 [[CMP77_NOT]], label [[IF_END87]], label [[IF_THEN:%.*]]
; CHECKOO:       if.then:
; CHECKOO-NEXT:    [[SUB79:%.*]] = add nsw i64 [[MUL]], -1
; CHECKOO-NEXT:    [[FLOW81:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB79]], i32 7
; CHECKOO-NEXT:    [[TMP8:%.*]] = load i64, ptr [[FLOW81]], align 8
; CHECKOO-NEXT:    [[FLOW83:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[MUL]], i32 7
; CHECKOO-NEXT:    [[TMP9:%.*]] = load i64, ptr [[FLOW83]], align 8
; CHECKOO-NEXT:    [[CMP84:%.*]] = icmp slt i64 [[TMP8]], [[TMP9]]
; CHECKOO-NEXT:    [[SPEC_SELECT_FROZEN:%.*]] = freeze i1 [[CMP84]]
; CHECKOO-NEXT:    br i1 [[SPEC_SELECT_FROZEN]], label [[SELECT_END:%.*]], label [[SELECT_FALSE:%.*]]
; CHECKOO:       select.false:
; CHECKOO-NEXT:    br label [[SELECT_END]]
; CHECKOO:       select.end:
; CHECKOO-NEXT:    [[SPEC_SELECT:%.*]] = phi i64 [ [[ADD]], [[IF_THEN]] ], [ [[MUL]], [[SELECT_FALSE]] ]
; CHECKOO-NEXT:    br label [[IF_END87]]
; CHECKOO:       if.end87:
; CHECKOO-NEXT:    [[CMP_1]] = phi i64 [ [[MUL]], [[WHILE_BODY]] ], [ [[SPEC_SELECT]], [[SELECT_END]] ]
; CHECKOO-NEXT:    [[CMP16_NOT:%.*]] = icmp sgt i64 [[CMP_1]], [[MA]]
; CHECKOO-NEXT:    br i1 [[CMP16_NOT]], label [[WHILE_END]], label [[LAND_RHS]]
; CHECKOO:       while.end:
; CHECKOO-NEXT:    ret void
;
; CHECKII-LABEL: @replace(
; CHECKII-NEXT:  entry:
; CHECKII-NEXT:    [[T1:%.*]] = getelementptr inbounds [[STRUCT_ST:%.*]], ptr [[NEWST:%.*]], i64 0, i32 2
; CHECKII-NEXT:    store ptr [[T:%.*]], ptr [[T1]], align 8
; CHECKII-NEXT:    [[H3:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 3
; CHECKII-NEXT:    store ptr [[H:%.*]], ptr [[H3]], align 8
; CHECKII-NEXT:    [[ORG_C:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 8
; CHECKII-NEXT:    store i64 [[C:%.*]], ptr [[ORG_C]], align 8
; CHECKII-NEXT:    [[C6:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 1
; CHECKII-NEXT:    store i64 [[C]], ptr [[C6]], align 8
; CHECKII-NEXT:    [[FLOW:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 0, i32 7
; CHECKII-NEXT:    store i64 [[RC:%.*]], ptr [[FLOW]], align 8
; CHECKII-NEXT:    [[CONV:%.*]] = trunc i64 [[N:%.*]] to i32
; CHECKII-NEXT:    store i32 [[CONV]], ptr [[NEWST]], align 8
; CHECKII-NEXT:    [[FLOW10:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 1, i32 7
; CHECKII-NEXT:    [[TMP0:%.*]] = load i64, ptr [[FLOW10]], align 8
; CHECKII-NEXT:    [[FLOW12:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 2, i32 7
; CHECKII-NEXT:    [[TMP1:%.*]] = load i64, ptr [[FLOW12]], align 8
; CHECKII-NEXT:    [[CMP13:%.*]] = icmp sgt i64 [[TMP0]], [[TMP1]]
; CHECKII-NEXT:    [[CONV15:%.*]] = select i1 [[CMP13]], i64 2, i64 3
; CHECKII-NEXT:    [[CMP16_NOT149:%.*]] = icmp sgt i64 [[CONV15]], [[MA:%.*]]
; CHECKII-NEXT:    br i1 [[CMP16_NOT149]], label [[WHILE_END:%.*]], label [[LAND_RHS:%.*]]
; CHECKII:       land.rhs:
; CHECKII-NEXT:    [[CMP_0151:%.*]] = phi i64 [ [[CMP_1:%.*]], [[IF_END87:%.*]] ], [ [[CONV15]], [[ENTRY:%.*]] ]
; CHECKII-NEXT:    [[POS_0150:%.*]] = phi i64 [ [[CMP_0151]], [[IF_END87]] ], [ 1, [[ENTRY]] ]
; CHECKII-NEXT:    [[SUB:%.*]] = add nsw i64 [[CMP_0151]], -1
; CHECKII-NEXT:    [[FLOW19:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 7
; CHECKII-NEXT:    [[TMP2:%.*]] = load i64, ptr [[FLOW19]], align 8
; CHECKII-NEXT:    [[CMP20:%.*]] = icmp sgt i64 [[TMP2]], [[RC]]
; CHECKII-NEXT:    br i1 [[CMP20]], label [[WHILE_BODY:%.*]], label [[WHILE_END]]
; CHECKII:       while.body:
; CHECKII-NEXT:    [[ARRAYIDX18:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]]
; CHECKII-NEXT:    [[T24:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 2
; CHECKII-NEXT:    [[TMP3:%.*]] = load ptr, ptr [[T24]], align 8
; CHECKII-NEXT:    [[SUB25:%.*]] = add nsw i64 [[POS_0150]], -1
; CHECKII-NEXT:    [[ARRAYIDX26:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]]
; CHECKII-NEXT:    [[T27:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 2
; CHECKII-NEXT:    store ptr [[TMP3]], ptr [[T27]], align 8
; CHECKII-NEXT:    [[H30:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 3
; CHECKII-NEXT:    [[TMP4:%.*]] = load ptr, ptr [[H30]], align 8
; CHECKII-NEXT:    [[H33:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 3
; CHECKII-NEXT:    store ptr [[TMP4]], ptr [[H33]], align 8
; CHECKII-NEXT:    [[C36:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 1
; CHECKII-NEXT:    [[TMP5:%.*]] = load i64, ptr [[C36]], align 8
; CHECKII-NEXT:    [[C39:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 1
; CHECKII-NEXT:    store i64 [[TMP5]], ptr [[C39]], align 8
; CHECKII-NEXT:    [[TMP6:%.*]] = load i64, ptr [[C36]], align 8
; CHECKII-NEXT:    [[ORG_C45:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 8
; CHECKII-NEXT:    store i64 [[TMP6]], ptr [[ORG_C45]], align 8
; CHECKII-NEXT:    [[FLOW51:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB25]], i32 7
; CHECKII-NEXT:    store i64 [[TMP2]], ptr [[FLOW51]], align 8
; CHECKII-NEXT:    [[TMP7:%.*]] = load i32, ptr [[ARRAYIDX18]], align 8
; CHECKII-NEXT:    store i32 [[TMP7]], ptr [[ARRAYIDX26]], align 8
; CHECKII-NEXT:    store ptr [[T]], ptr [[T24]], align 8
; CHECKII-NEXT:    store ptr [[H]], ptr [[H30]], align 8
; CHECKII-NEXT:    store i64 [[C]], ptr [[C36]], align 8
; CHECKII-NEXT:    [[ORG_C69:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB]], i32 8
; CHECKII-NEXT:    store i64 [[C]], ptr [[ORG_C69]], align 8
; CHECKII-NEXT:    store i64 [[RC]], ptr [[FLOW19]], align 8
; CHECKII-NEXT:    store i32 [[CONV]], ptr [[ARRAYIDX18]], align 8
; CHECKII-NEXT:    [[MUL:%.*]] = shl nsw i64 [[CMP_0151]], 1
; CHECKII-NEXT:    [[ADD:%.*]] = or i64 [[MUL]], 1
; CHECKII-NEXT:    [[CMP77_NOT:%.*]] = icmp sgt i64 [[ADD]], [[MA]]
; CHECKII-NEXT:    br i1 [[CMP77_NOT]], label [[IF_END87]], label [[IF_THEN:%.*]]
; CHECKII:       if.then:
; CHECKII-NEXT:    [[SUB79:%.*]] = add nsw i64 [[MUL]], -1
; CHECKII-NEXT:    [[FLOW81:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[SUB79]], i32 7
; CHECKII-NEXT:    [[TMP8:%.*]] = load i64, ptr [[FLOW81]], align 8
; CHECKII-NEXT:    [[FLOW83:%.*]] = getelementptr inbounds [[STRUCT_ST]], ptr [[NEWST]], i64 [[MUL]], i32 7
; CHECKII-NEXT:    [[TMP9:%.*]] = load i64, ptr [[FLOW83]], align 8
; CHECKII-NEXT:    [[CMP84:%.*]] = icmp slt i64 [[TMP8]], [[TMP9]]
; CHECKII-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[CMP84]], i64 [[ADD]], i64 [[MUL]]
; CHECKII-NEXT:    br label [[IF_END87]]
; CHECKII:       if.end87:
; CHECKII-NEXT:    [[CMP_1]] = phi i64 [ [[MUL]], [[WHILE_BODY]] ], [ [[SPEC_SELECT]], [[IF_THEN]] ]
; CHECKII-NEXT:    [[CMP16_NOT:%.*]] = icmp sgt i64 [[CMP_1]], [[MA]]
; CHECKII-NEXT:    br i1 [[CMP16_NOT]], label [[WHILE_END]], label [[LAND_RHS]]
; CHECKII:       while.end:
; CHECKII-NEXT:    ret void
;
entry:
  %t1 = getelementptr inbounds %struct.st, ptr %newst, i64 0, i32 2
  store ptr %t, ptr %t1, align 8
  %h3 = getelementptr inbounds %struct.st, ptr %newst, i64 0, i32 3
  store ptr %h, ptr %h3, align 8
  %org_c = getelementptr inbounds %struct.st, ptr %newst, i64 0, i32 8
  store i64 %c, ptr %org_c, align 8
  %c6 = getelementptr inbounds %struct.st, ptr %newst, i64 0, i32 1
  store i64 %c, ptr %c6, align 8
  %flow = getelementptr inbounds %struct.st, ptr %newst, i64 0, i32 7
  store i64 %rc, ptr %flow, align 8
  %conv = trunc i64 %n to i32
  store i32 %conv, ptr %newst, align 8
  %flow10 = getelementptr inbounds %struct.st, ptr %newst, i64 1, i32 7
  %0 = load i64, ptr %flow10, align 8
  %flow12 = getelementptr inbounds %struct.st, ptr %newst, i64 2, i32 7
  %1 = load i64, ptr %flow12, align 8
  %cmp13 = icmp sgt i64 %0, %1
  %conv15 = select i1 %cmp13, i64 2, i64 3
  %cmp16.not149 = icmp sgt i64 %conv15, %ma
  br i1 %cmp16.not149, label %while.end, label %land.rhs

land.rhs:                                         ; preds = %entry, %if.end87
  %cmp.0151 = phi i64 [ %cmp.1, %if.end87 ], [ %conv15, %entry ]
  %pos.0150 = phi i64 [ %cmp.0151, %if.end87 ], [ 1, %entry ]
  %sub = add nsw i64 %cmp.0151, -1
  %flow19 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub, i32 7
  %2 = load i64, ptr %flow19, align 8
  %cmp20 = icmp sgt i64 %2, %rc
  br i1 %cmp20, label %while.body, label %while.end

while.body:                                       ; preds = %land.rhs
  %arrayidx18 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub
  %t24 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub, i32 2
  %3 = load ptr, ptr %t24, align 8
  %sub25 = add nsw i64 %pos.0150, -1
  %arrayidx26 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub25
  %t27 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub25, i32 2
  store ptr %3, ptr %t27, align 8
  %h30 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub, i32 3
  %4 = load ptr, ptr %h30, align 8
  %h33 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub25, i32 3
  store ptr %4, ptr %h33, align 8
  %c36 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub, i32 1
  %5 = load i64, ptr %c36, align 8
  %c39 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub25, i32 1
  store i64 %5, ptr %c39, align 8
  %6 = load i64, ptr %c36, align 8
  %org_c45 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub25, i32 8
  store i64 %6, ptr %org_c45, align 8
  %flow51 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub25, i32 7
  store i64 %2, ptr %flow51, align 8
  %7 = load i32, ptr %arrayidx18, align 8
  store i32 %7, ptr %arrayidx26, align 8
  store ptr %t, ptr %t24, align 8
  store ptr %h, ptr %h30, align 8
  store i64 %c, ptr %c36, align 8
  %org_c69 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub, i32 8
  store i64 %c, ptr %org_c69, align 8
  store i64 %rc, ptr %flow19, align 8
  store i32 %conv, ptr %arrayidx18, align 8
  %mul = shl nsw i64 %cmp.0151, 1
  %add = or i64 %mul, 1
  %cmp77.not = icmp sgt i64 %add, %ma
  br i1 %cmp77.not, label %if.end87, label %if.then

if.then:                                          ; preds = %while.body
  %sub79 = add nsw i64 %mul, -1
  %flow81 = getelementptr inbounds %struct.st, ptr %newst, i64 %sub79, i32 7
  %8 = load i64, ptr %flow81, align 8
  %flow83 = getelementptr inbounds %struct.st, ptr %newst, i64 %mul, i32 7
  %9 = load i64, ptr %flow83, align 8
  %cmp84 = icmp slt i64 %8, %9
  %spec.select = select i1 %cmp84, i64 %add, i64 %mul
  br label %if.end87

if.end87:                                         ; preds = %if.then, %while.body
  %cmp.1 = phi i64 [ %mul, %while.body ], [ %spec.select, %if.then ]
  %cmp16.not = icmp sgt i64 %cmp.1, %ma
  br i1 %cmp16.not, label %while.end, label %land.rhs

while.end:                                        ; preds = %land.rhs, %if.end87, %entry
  ret void
}
