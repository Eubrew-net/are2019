Para a�adir los checklist al report:

1) A�ade el paquete pdflscape en el pre�mbulo (\usepackage{pdflscape})
   
2) \input{checklist_###} al final (antes de \end{document}, claro)

Lo mejor es trabajar con la plantilla actualizada (iberonesia/latex). En todo caso, siempre se puede usar el m�todo anterior


Para generar el fichero correspondiente: 

1) descarga el checklist (mejor en formato xls)
2) use read_checklists(filename,sheet), donde:  (matlab/calibration/tools)

	i ) filename=path absoluto al fichero
	ii) sheet=hoja correspondiente

Si todo va bien, la funci�n te genera un fichero checklist_###.tex y te lo pone en latex/###



