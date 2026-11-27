# Prueba integral en Active-HDL con Waveform completo (TP10 - Escenario 4c)
# Ejecutar desde la consola de Active-HDL:
#   do C:/Aldec/My_Designs/TDA_1819/TDA_1819/prueba_integral_wave.do

# Programa por defecto: fwd_suma.asm (cauce + adelantamiento).
# Para cambiar de programa, modificar -GProgName="fwd_suma_reord.asm" o "fwd_prodesc.asm".
asim -t ns -O5 +access +r +m+usuario -GProgName="fwd_suma.asm" -GPipelining=true -GForwarding=true usuario USUARIO_ARCHITECTURE

# Reloj y control de atascos / adelantamiento
wave /usuario/UUT/UUT2/CLK
wave /usuario/UUT/UUT2/StallRAW
wave /usuario/UUT/UUT2/FwdRAW
wave /usuario/UUT/UUT2/FwdEnableID
wave /usuario/UUT/UUT2/IdRegFwdMA
wave /usuario/UUT/UUT2/EXFPUPendingFwd

# Registros generales clave (R1/R5 productores, R4 acumulador/resultado)
wave -radix hex /usuario/UUT/UUT2/UUT7/R1
wave -radix hex /usuario/UUT/UUT2/UUT7/R4
wave -radix hex /usuario/UUT/UUT2/UUT7/R5

# Registros de segmentacion (ID/EX y MEM/WB) y estado del cauce
wave /usuario/UUT/UUT2/IDtoEX
wave /usuario/UUT/UUT2/RecInWB
wave /usuario/UUT/UUT2/UUT1/UUT1/InstStatesExec

run
