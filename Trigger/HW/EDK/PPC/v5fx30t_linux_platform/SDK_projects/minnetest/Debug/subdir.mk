################################################################################
# Automatically-generated file. Do not edit!
################################################################################

S_UPPER_SRCS += \

CC_UPPER_SRCS += \

C++_UPPER_SRCS += \

CXX_UPPER_SRCS += \

CPP_SRCS += \

CC_SRCS += \

C_SRCS += \
../main.c \

C_UPPER_SRCS += \

CPP_UPPER_SRCS += \

CXX_SRCS += \

S_SRCS += \

C++_SRCS += \

# Object files
OBJS += \
main.o \

# Dependency files
DEPS += \
main.d \

# Each subdirectory must supply rules for building sources it contributes
main.o: ../main.c $(INCDEP)
	@echo powerpc-eabi-gcc -c -mcpu=440  -I../../ppc440_0_sw_platform/ppc440_0/include -g -O0 -o$@ $<
	@powerpc-eabi-gcc -c -mcpu=440  -I../../ppc440_0_sw_platform/ppc440_0/include -g -O0 -o$@ $< && \
	echo -n $(@:%.o=%.d) $(dir $@) > $(@:%.o=%.d) && \
	powerpc-eabi-gcc -I../../ppc440_0_sw_platform/ppc440_0/include -MM -MG -P -w -g -O0  $< >> $(@:%.o=%.d)
	@echo ' '


