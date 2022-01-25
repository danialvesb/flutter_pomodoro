import 'dart:async';

import 'package:mobx/mobx.dart';

part 'pomodoro.store.g.dart';

class PomodoroStore = _PomodoroStore with _$PomodoroStore;

enum TipoIntervalo { TRABALHO, DESCANSO }

abstract class _PomodoroStore with Store {
  @observable
  bool iniciado = false;

  @observable
  int minutos = 2;

  @observable
  int segundos = 0;

  @observable
  int tempoTrabalho = 2;

  @observable
  int tempoDescanco = 1;

  @observable
  TipoIntervalo tipoIntervalo = TipoIntervalo.TRABALHO;

  Timer? cronometro;

  @action
  void iniciar() {
    iniciado = true;

    cronometro = Timer.periodic(
        const Duration(
          seconds: 1,
        ), (timer) {
      if (minutos == 0 && segundos == 0) {
        _trocarTipoIntervalo();
      } else if (segundos == 0) {
        segundos = 59;
        minutos--;
      } else {
        segundos--;
      }
    });
  }

  @action
  void parar() {
    iniciado = false;

    cronometro?.cancel();
  }

  @action
  void reiniciar() {
    iniciado = false;

    parar();

    minutos = estaTrabalhando() ? tempoTrabalho : tempoDescanco;
    segundos = 0;
  }

  @action
  void increMentarTempoTrabalho() {
    tempoTrabalho++;

    if (estaTrabalhando()) {
      reiniciar();
    }
  }

  @action
  void decrementarTempoTrabalho() {
    tempoTrabalho--;

    if (estaTrabalhando()) {
      reiniciar();
    }
  }

  @action
  void increMentarTempoDescanco() {
    tempoDescanco++;

    if (estaDescansando()) {
      reiniciar();
    }
  }

  @action
  void decrementarTempoDescanco() {
    tempoDescanco--;

    if (estaDescansando()) {
      reiniciar();
    }
  }

  bool estaTrabalhando() {
    return tipoIntervalo == TipoIntervalo.TRABALHO;
  }

  bool estaDescansando() {
    return tipoIntervalo == TipoIntervalo.DESCANSO;
  }

  void _trocarTipoIntervalo() {
    if (estaDescansando()) {
      tipoIntervalo = TipoIntervalo.TRABALHO;

      minutos = tempoDescanco;
    } else {
      tipoIntervalo = TipoIntervalo.DESCANSO;

      minutos = tempoTrabalho;
    }

    segundos = 0;
  }
}
