#!/usr/bin/python

from __future__ import print_function

import optparse
import os
import sys
import glob

root_dir = os.path.dirname(__file__)

supported_archs = ['pnr', 'nhm', 'snb', 'ivb', 'hsw', 'mic', 'pld', 'nhm+mic', 'snb+mic', 'ivb+mic', 'hsw+mic']
for arg in sys.argv[1:]:
	if arg not in supported_archs:
		print('Unsupported arch: "%s"' % arg)
		print('\tSupported architectures: %s' % ", ".join(supported_archs))
		sys.exit(1)
if len(sys.argv) == 1:
	print('Usage: configure.py [arch...]')
	sys.exit(1)
	

erd_ref_sources = [
	"erd__1111_csgto.f", "erd__1111_def_blocks.f", "erd__2d_atom_coefficients.f", "erd__2d_atom_pq_integrals.f",
	"erd__2d_coefficients.f", "erd__2d_pq_integrals.f", "erd__atom_int2d_to_e000.f", "erd__atom_int2d_to_e0f0.f",
	"erd__cartesian_norms.f", "erd__csgto.f", "erd__ctr_1st_half.f", "erd__ctr_2nd_half_new.f",
	"erd__ctr_2nd_half_update.f", "erd__ctr_4index_block.f", "erd__ctr_4index_reorder.f", "erd__ctr_rs_expand.f",
	"erd__ctr_tu_expand.f", "erd__dsqmin_line_segments.f", "erd__e0f0_def_blocks.f", "erd__e0f0_pcgto_block.f",
	"erd__gener_eri_batch.f", "erd__hrr_matrix.f", "erd__hrr_step.f", "erd__hrr_transform.f",
	"erd__int2d_to_e000.f", "erd__int2d_to_e0f0.f", "erd__map_ijkl_to_ikjl.f", "erd__memory_1111_csgto.f",
	"erd__memory_csgto.f", "erd__memory_eri_batch.f", "erd__move_ry.f", "erd__normalize_cartesian.f",
	"erd__pppp_pcgto_block.f", "erd__rys_1_roots_weights.f", "erd__rys_2_roots_weights.f", "erd__rys_3_roots_weights.f",
	"erd__rys_4_roots_weights.f", "erd__rys_5_roots_weights.f", "erd__rys_roots_weights.f", "erd__rys_x_roots_weights.f",
	"erd__set_abcd.f", "erd__set_ij_kl_pairs.f", "erd__spherical_transform.f", "erd__sppp_pcgto_block.f",
	"erd__sspp_pcgto_block.f", "erd__sssp_pcgto_block.f", "erd__ssss_pcgto_block.f", "erd__transpose_batch.f",
	"erd__xyz_to_ry_abcd.f", "erd__xyz_to_ry_matrix.f", "erd__prepare_ctr.F",
	"erd_profile.c"
]

erd_opt_sources = [
	'erd__memory_csgto.c',
	"erd__1111_csgto.c", "erd__2d_coefficients.c", "erd__2d_pq_integrals.c",
	"erd__boys_table.c", "erd__jacobi_table.c", "erd__cartesian_norms.c", "erd__csgto.c",
	"erd__dsqmin_line_segments.c", "erd__e0f0_pcgto_block.c", "erd__hrr_matrix.c",
	"erd__hrr_step.c", "erd__hrr_transform.c", "erd__int2d_to_e000.c", "erd__int2d_to_e0f0.c",
	"erd__move_ry.c", "erd__normalize_cartesian.c",
	"erd__pppp_pcgto_block.c", "erd__rys_1_roots_weights.c", "erd__rys_2_roots_weights.c", "erd__rys_3_roots_weights.c",
	"erd__rys_4_roots_weights.c", "erd__rys_5_roots_weights.c", "erd__rys_roots_weights.c", "erd__rys_x_roots_weights.c",
	"erd__set_abcd.c", "erd__set_ij_kl_pairs.c", "erd__spherical_transform.c", "erd__sppp_pcgto_block.c",
	"erd__sspp_pcgto_block.c", "erd__sssp_pcgto_block.c", "erd__ssss_pcgto_block.c", "erd__xyz_to_ry_abcd.c",
	"erd__xyz_to_ry_matrix.c",
	"erd_profile.c"
]

oed_sources = [
	"oed__cartesian_norms.f", "oed__ctr_2index_block.f", "oed__ctr_2index_reorder.f", "oed__ctr_3index_block.f", "oed__ctr_3index_reorder.f",
	"oed__ctr_pair_new.f", "oed__ctr_pair_update.f", "oed__ctr_rs_expand.f", "oed__ctr_single_new.f", "oed__ctr_single_update.f",
	"oed__dsqmin_line_segments.f", "oed__gener_kin_batch.f", "oed__gener_kin_derv_batch.f", "oed__gener_nai_batch.f", "oed__gener_nai_derv_batch.f",
	"oed__gener_ovl3c_batch.f", "oed__gener_ovl_batch.f", "oed__gener_ovl_derv_batch.f", "oed__gener_xyz_batch.f", "oed__gener_xyz_derv_batch.f",
	"oed__hrr_matrix.f", "oed__hrr_step.f", "oed__hrr_transform.f", "oed__kin_1d_derv_integrals.f", "oed__kin_1d_integrals.f",
	"oed__kin_ab_def_blocks.f", "oed__kin_ab_pcgto_block.f", "oed__kin_csgto.f", "oed__kin_derv_csgto.f", "oed__kin_derv_def_blocks.f",
	"oed__kin_derv_int1d_to_00.f", "oed__kin_derv_int1d_to_a0.f", "oed__kin_derv_int1d_to_ab.f", "oed__kin_derv_pcgto_block.f", "oed__kin_int1d_to_a0.f",
	"oed__kin_int1d_to_ab.f", "oed__kin_prepare_ctr.f", "oed__kin_set_ab.f", "oed__kin_set_derv_ab.f", "oed__kin_set_derv_sequence.f",
	"oed__kin_set_ij_pairs.f", "oed__map_ijkl_to_ikjl.f", "oed__memory_kin_batch.f", "oed__memory_kin_csgto.f", "oed__memory_kin_derv_batch.f",
	"oed__memory_kin_derv_csgto.f", "oed__memory_nai_batch.f", "oed__memory_nai_csgto.f", "oed__memory_nai_derv_batch.f", "oed__memory_nai_derv_csgto.f",
	"oed__memory_ovl3c_batch.f", "oed__memory_ovl3c_csgto.f", "oed__memory_ovl_batch.f", "oed__memory_ovl_csgto.f", "oed__memory_ovl_derv_batch.f",
	"oed__memory_ovl_derv_csgto.f", "oed__move_ry.f", "oed__nai_1d_ab_integrals.f", "oed__nai_1d_cenderv_integrals.f", "oed__nai_1d_coefficients.f",
	"oed__nai_1d_p_integrals.f", "oed__nai_1d_shderv_integrals.f", "oed__nai_csgto.f", "oed__nai_derv_2cen_pcgto_block.f", "oed__nai_derv_3cen_pcgto_block.f",
	"oed__nai_derv_csgto.f", "oed__nai_derv_def_blocks.f", "oed__nai_derv_int1d_to_00.f", "oed__nai_derv_int1d_to_a0.f", "oed__nai_derv_int1d_to_ab.f",
	"oed__nai_e0_def_blocks.f", "oed__nai_e0_pcgto_block.f", "oed__nai_int1d_to_e0.f", "oed__nai_prepare_ctr.F", "oed__nai_set_ab.f",
	"oed__nai_set_derv_ab.f", "oed__nai_set_derv_ijc_triples.f", "oed__nai_set_ijc_triples.f", "oed__normalize_cartesian.f", "oed__ovl_1d_ab_integrals.f",
	"oed__ovl_1d_derv_integrals.f", "oed__ovl_1d_integrals.f", "oed__ovl3c_csgto.f", "oed__ovl3c_f00_def_blocks.f", "oed__ovl3c_f00_pcgto_block.f",
	"oed__ovl3c_prepare_ctr.F", "oed__ovl3c_set_abc.f", "oed__ovl3c_set_ijk.f", "oed__ovl3c_set_ijk_triples.f", "oed__ovl_csgto.f",
	"oed__ovl_derv_csgto.f", "oed__ovl_derv_def_blocks.f", "oed__ovl_derv_int1d_to_00.f", "oed__ovl_derv_int1d_to_a0.f", "oed__ovl_derv_int1d_to_ab.f",
	"oed__ovl_derv_pcgto_block.f", "oed__ovl_e0_def_blocks.f", "oed__ovl_e0_pcgto_block.f", "oed__ovl_int1d_to_e0.f", "oed__ovl_prepare_ctr.F",
	"oed__ovl_set_ab.f", "oed__ovl_set_derv_ab.f", "oed__ovl_set_derv_sequence.f", "oed__ovl_set_ij_pairs.f", "oed__print_2ind_batch.f",
	"oed__print_batch.f", "oed__rys_1_roots_weights.f", "oed__rys_2_roots_weights.f", "oed__rys_3_roots_weights.f", "oed__rys_4_roots_weights.f",
	"oed__rys_5_roots_weights.f", "oed__rys_roots_weights.f", "oed__rys_x_roots_weights.f", "oed__spherical_transform.f", "oed__transpose_batch.f",
	"oed__xyz_1d_ab_integrals.f", "oed__xyz_1d_derv_integrals.f", "oed__xyz_1d_integrals.f", "oed__xyz_1d_mom_ab_integrals.f",
	"oed__xyz_1d_ovl_mom_ab_integrals.f", "oed__xyz_csgto.f", "oed__xyz_derv_csgto.f", "oed__xyz_derv_def_blocks.f", "oed__xyz_derv_int1d_to_00.f",
	"oed__xyz_derv_int1d_to_a0.f", "oed__xyz_derv_int1d_to_ab.f", "oed__xyz_derv_pcgto_block.f", "oed__xyz_e0_def_blocks.f", "oed__xyz_e0_pcgto_block.f",
	"oed__xyz_init_00_ints.f", "oed__xyz_init_ovrlp.f", "oed__xyz_int1d_to_e0.f", "oed__xyz_mom_integrals.f", "oed__xyz_set_ab.f", "oed__xyz_set_derv_ab.f",
	"oed__xyz_set_derv_sequence.f", "oed__xyz_to_ry_abc.f", "oed__xyz_to_ry_ab.f", "oed__xyz_to_ry_matrix.f"
]

cint_sources = ["basisset.c", "erd_integral.c", "oed_integral.c", "cint_offload.c"]

tab = '  '

with open('build.ninja', 'w') as makefile:
	print('FC_PNR = ifort -m64 -xSSE4.1', file = makefile)
	print('FC_NHM = ifort -m64 -xSSE4.2', file = makefile)
	print('FC_SNB = ifort -m64 -xAVX ', file = makefile)
	print('FC_IVB = ifort -m64 -xCORE-AVX-I', file = makefile)
	print('FC_HSW = ifort -m64 -xCORE-AVX2', file = makefile)
	print('FC_MIC = ifort -mmic', file = makefile)
	print('FC_PLD = ifort -m64 -mavx -fma', file = makefile)
	print('FC_NHM_OFFLOAD = $FC_NHM', file = makefile)
	print('FC_SNB_OFFLOAD = $FC_SNB', file = makefile)
	print('FC_IVB_OFFLOAD = $FC_IVB', file = makefile)
	print('FC_HSW_OFFLOAD = $FC_HSW', file = makefile)
	print('FFLAGS = -O3 -g -reentrancy threaded -recursive', file = makefile)
	native_cflags = '-D__ERD_PROFILE__ -offload=none -diag-disable 161,2423'
	offload_cflags = '-offload-option,mic,compiler,"-z defs -no-opt-prefetch"'
	print('CC_PNR = icc -m64 -xSSE4.1 -DERD_PNR ' + native_cflags, file = makefile)
	print('CC_NHM = icc -m64 -xSSE4.2 -DERD_NHM ' + native_cflags, file = makefile)
	print('CC_SNB = icc -m64 -xAVX -DERD_SNB ' + native_cflags, file = makefile)
	print('CC_IVB = icc -m64 -xCORE-AVX-I -DERD_IVB ' + native_cflags, file = makefile)
	print('CC_HSW = icc -m64 -xCORE-AVX2 -DERD_HSW ' + native_cflags, file = makefile)
	print('CC_MIC = icc -mmic -no-opt-prefetch -DERD_MIC ' + native_cflags, file = makefile)
	print('CC_PLD = icc -m64 -mavx -fma -DERD_PLD ' + native_cflags, file = makefile)
	print('CC_NHM_OFFLOAD = icc -m64 -xSSE4.2 -DERD_NHM ' + offload_cflags, file = makefile)
	print('CC_SNB_OFFLOAD = icc -m64 -xAVX -DERD_SNB ' + offload_cflags, file = makefile)
	print('CC_IVB_OFFLOAD = icc -m64 -xCORE-AVX-I -DERD_IVB ' + offload_cflags, file = makefile)
	print('CC_HSW_OFFLOAD = icc -m64 -xCORE-AVX2 -DERD_HSW ' + offload_cflags, file = makefile)
	print('CFLAGS = -O3 -g -std=gnu99 -D__ALIGNLEN__=64 -Wall -Wextra -Werror -Wno-unused-variable -openmp', file = makefile)
	print('LDFLAGS = -static-intel -lifcore -openmp -lrt', file = makefile)
	print('AR = xiar', file = makefile)
	print('AR_OFFLOAD = xiar -qoffload-build', file = makefile)

	suffix = {
		'pnr': 'PNR',
		'nhm': 'NHM',
		'snb': 'SNB',
		'ivb': 'IVB',
		'hsw': 'HSW',
		'mic': 'MIC',
		'pld': 'PLD',
		'nhm+mic': 'NHM_OFFLOAD',
		'snb+mic': 'SNB_OFFLOAD',
		'ivb+mic': 'IVB_OFFLOAD',
		'hsw+mic': 'HSW_OFFLOAD'
	}

	print('rule COMPILE_F90', file = makefile)
	print(tab + 'command = $FC $FFLAGS -o $out -c $in', file = makefile)
	print(tab + 'description = F90[$ARCH] $in', file = makefile)

	print('rule COMPILE_F77', file = makefile)
	print(tab + 'command = $FC $FFLAGS -o $out -c $in', file = makefile)
	print(tab + 'description = F77[$ARCH] $in', file = makefile)

	print('rule COMPILE_C', file = makefile)
	print(tab + 'depfile = $DEP_FILE', file = makefile)
	print(tab + 'command = $CC $CFLAGS -MMD -MT $out -MF $DEP_FILE -o $out -c $SOURCE', file = makefile)
	print(tab + 'description = CC[$ARCH] $in', file = makefile)

	print('rule LINK', file = makefile)
	print(tab + 'command = $CC $CFLAGS -o $out $in $LDFLAGS', file = makefile)
	print(tab + 'description = CCLD[$ARCH] $out', file = makefile)

	print('rule CREATE_STATIC_LIBRARY', file = makefile)
	print(tab + 'command = $AR rcs $out $in', file = makefile)
	print(tab + 'description = AR[$ARCH] $out', file = makefile)

	print('rule GENERATE_HEADER', file = makefile)
	print(tab + 'command = cd $WORKDIR && bash $SCRIPT', file = makefile)
	print(tab + 'description = SH $SCRIPT', file = makefile)

	for version in ["ref", "opt"]:
		cint_source_directory = "libcint"
		cint_include_directory = os.path.join("include")
		if version == "ref":
			cint_source_directory = os.path.join("legacy", cint_source_directory)
			cint_include_directory = os.path.join("legacy", cint_include_directory)

		print('build %s : GENERATE_HEADER %s %s' % (os.path.join(cint_include_directory, 'CInt.h'), os.path.join(cint_source_directory, 'genheader.sh'), os.path.join(cint_source_directory, 'cint_def.h')), file = makefile)
		print(tab + 'SCRIPT = %s' % 'genheader.sh', file = makefile)
		print(tab + 'WORKDIR = %s' % cint_source_directory, file = makefile)

		for arch in sys.argv[1:]:
			erd_source_directory = os.path.join({"ref": "legacy", "opt": "external"}[version], "erd")
			erd_build_directory = os.path.join(erd_source_directory, arch)
			erd_objects = list()
			erd_sources = {"ref": erd_ref_sources, "opt": erd_opt_sources}[version]
			for source_file in erd_sources:
				object_file = os.path.join(erd_build_directory, source_file + '.o')
				dep_file = os.path.join(erd_build_directory, source_file + '.d')
				source_file = os.path.join(erd_source_directory, source_file)
				erd_objects.append(object_file)
				if source_file.endswith('.f'):
					print('build %s : COMPILE_F90 %s' % (object_file, source_file), file = makefile)
					print(tab + 'FC = $FC_%s' % suffix[arch], file = makefile)
				elif source_file.endswith('.F'):
					print('build %s : COMPILE_F77 %s' % (object_file, source_file), file = makefile)
					print(tab + 'FC = $FC_%s' % suffix[arch], file = makefile)
				elif source_file.endswith('.c'):
					print('build %s : COMPILE_C %s' % (object_file, source_file), file = makefile)
					print(tab + 'SOURCE = ' + source_file, file = makefile)
					print(tab + 'DEP_FILE = ' + dep_file, file = makefile)
					print(tab + 'CC = $CC_%s' % suffix[arch], file = makefile)
				else:
					assert False
				print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			print('build lib/' + arch + '/liberd-' + version + '.a : CREATE_STATIC_LIBRARY ' + ' '.join(erd_objects), file = makefile)
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			oed_source_directory = os.path.join({"ref": "legacy", "opt": "external"}[version], "oed")
			oed_build_directory = os.path.join(oed_source_directory, arch)
			oed_objects = list()
			for source_file in oed_sources:
				object_file = os.path.join(oed_build_directory, source_file + '.o')
				oed_objects.append(object_file)
				source_file = os.path.join(oed_source_directory, source_file)
				if source_file.endswith('.f'):
					print('build %s : COMPILE_F90 %s' % (object_file, source_file), file = makefile)
					print(tab + 'FC = $FC_%s' % suffix[arch], file = makefile)
				elif source_file.endswith('.F'):
					print('build %s : COMPILE_F77 %s' % (object_file, source_file), file = makefile)
					print(tab + 'FC = $FC_%s' % suffix[arch], file = makefile)
				else:
					assert False
				print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			print('build lib/' + arch + '/liboed-' + version +'.a : CREATE_STATIC_LIBRARY ' + ' '.join(oed_objects), file = makefile)
			if arch.endswith('+mic'):
				print(tab + 'AR = $AR_OFFLOAD', file = makefile);
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			cint_build_directory = os.path.join(cint_source_directory, arch)
			cint_objects = list()
			for source_file in cint_sources:
				if source_file == "cint_offload.c" and version != "opt":
					continue

				object_file = os.path.join(cint_build_directory, source_file + '.o')
				dep_file = os.path.join(cint_build_directory, source_file + '.d')
				source_file = os.path.join(cint_source_directory, source_file)
				cint_objects.append(object_file)

				print('build %s : COMPILE_C %s' % (object_file, source_file), file = makefile)
				print(tab + 'DEP_FILE = ' + dep_file, file = makefile)
				print(tab + 'SOURCE = ' + source_file, file = makefile)
				print(tab + 'CC = $CC_%s' % suffix[arch], file = makefile)
				print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			print('build lib/' + arch + '/libcint-' + version + '.a : CREATE_STATIC_LIBRARY ' + ' '.join(cint_objects), file = makefile)
			if arch.endswith('+mic'):
				print(tab + 'AR = $AR_OFFLOAD', file = makefile);
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			test_directory = 'testprog'
			if version == 'ref':
				test_directory = os.path.join('legacy', test_directory)

			screening_object_file = '%s/%s/screening.c.o' % (test_directory, arch)
			print('build %s : COMPILE_C %s/screening.c include/CInt.h' % (screening_object_file, test_directory), file = makefile)
			print(tab + 'DEP_FILE = %s/%s/screening.c.d' % (test_directory, arch), file = makefile)
			print(tab + 'SOURCE = %s/screening.c' % test_directory, file = makefile)
			print(tab + 'CC = $CC_%s' % suffix[arch], file = makefile)
			print(tab + 'CFLAGS = $CFLAGS -openmp' +
				' -I' + {'opt': 'include', 'ref': os.path.join('legacy', 'include')}[version], file = makefile)
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			object_file = '%s/%s/testCInt.c.%s.o' % (test_directory, arch, version)
			print('build %s : COMPILE_C %s/testCInt.c include/CInt.h' % (object_file, test_directory), file = makefile)
			print(tab + 'DEP_FILE = %s.d' % object_file, file = makefile)
			print(tab + 'SOURCE = %s/testCInt.c' % test_directory, file = makefile)
			print(tab + 'CC = $CC_%s' % suffix[arch], file = makefile)
			print(tab + 'CFLAGS = $CFLAGS -Iexternal/erd -I%s' % test_directory +
				' -I' + {'opt': 'include', 'ref': os.path.join('legacy', 'include')}[version], file = makefile)
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			binary_file = 'testprog/%s/Test.%s' % (arch, version.title())
			libs = " ".join(['lib/' + arch + '/lib' + lib + '-' + version + '.a' for lib in ['cint', 'oed', 'erd']])
			print('build %s : LINK %s %s %s' % (binary_file, object_file, screening_object_file, libs), file = makefile)
			print(tab + 'CC = $CC_%s' % suffix[arch], file = makefile)
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			object_file = '%s/%s/testCInt2.c.%s.o' % (test_directory, arch, version)
			print('build %s : COMPILE_C %s/testCInt2.c include/CInt.h' % (object_file, test_directory), file = makefile)
			print(tab + 'DEP_FILE = %s.d' % object_file, file = makefile)
			print(tab + 'SOURCE = %s/testCInt2.c' % test_directory, file = makefile)
			print(tab + 'CC = $CC_%s' % suffix[arch], file = makefile)
			print(tab + 'CFLAGS = $CFLAGS -Iexternal/erd -I%s' % test_directory +
				' -I' + {'opt': 'include', 'ref': os.path.join('legacy', 'include')}[version], file = makefile)
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)

			binary_file = 'testprog/%s/Bench.%s' % (arch, version.title())
			libs = " ".join(['lib/' + arch + '/lib' + lib + '-' + version + '.a' for lib in ['cint', 'oed', 'erd']])
			print('build %s : LINK %s %s %s' % (binary_file, object_file, screening_object_file, libs), file = makefile)
			print(tab + 'CC = $CC_%s' % suffix[arch], file = makefile)
			print(tab + 'ARCH = %s' % arch.upper(), file = makefile)
