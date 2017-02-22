
File Groups & Folders
=====================

Runtime 
-------

Actually implemented:
query_image_size_[lod] (various_image_types image) { ... }

Declared 

convert [vector of] float type to [vector of] unsigned type [saturated] [rounding mode]
convert [vector of] float type to [vector of]   signed type [saturated] [rounding mode]

convert [vector of] unsigned type to [vector of] float type [saturated] [rounding mode]
convert [vector of]   signed type to [vector of] float type [saturated] [rounding mode]

integer conversion function

floating point conversion functions from and to half float double [round mode]

signed <-> unsigned saturated conversion

Course of Action: replace with an intrinsics.td

OCL*
----

Largely if not completely redundant with the use of an intrinsics.td

Course of Action:
remove if completely redundant or replace if not

Mangling
--------

Completely redundant with the use of an intrinsics.td

Course of Action: remove

libSPIRV
--------

"AST" of SPIRV Modules

SPIRV*
------
