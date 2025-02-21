<template>
  <div class="heading">
    <div>РАЗДЕЛ IV.</div>
    <div>ОБЪЕКТЫ СОРТИРОВКИ И ПЕРЕРАБОТКИ ТВЕРДЫХ КОММУНАЛЬНЫХ ОТХОДОВ.</div>
  </div>

  <!-- Table -->
  <table class="row" style="border: 1px solid; border-collapse: collapse">
    <tbody>
      <tr>
        <th class="cell">Наименование показателя</th>
        <th class="cell">Номер строки</th>
        <th class="cell">Количество объектов, ед.</th>
        <th class="cell">Установленная мощность, тыс. т в год</th>
        <th class="cell">Пропущено твердых коммунальных отходов (сумма граф 4 и 5), тыс. т</th>
        <th class="cell">Отобрано вторичных материальных ресурсов, тыс. т</th>
        <th class="cell">Отправлено отходов на захоронение, тыс. т</th>
      </tr>
      <tr v-for="row in rows" :key="row.name">
        <td class="cell">{{ row.name }}</td>
        <td class="cell text-center">{{ row.number }}</td>
        <td class="cell" v-for="value in row.values" :key="value.toString()">
          <q-input v-model="data[value]" class="text-center"></q-input>
        </td>
      </tr>
    </tbody>
  </table>
  <q-btn @click="foo">sdsd</q-btn>
  <q-page padding class="page-with-table"> </q-page>
</template>

<script setup>
import { ref } from 'Vue'
const data = ref([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20])

const range = (start, end) => {
  let array = []
  for (let i = 0; start < end; i++) {
    array[i] = start
    start++
  }
  return array
}

const rows = ref([
  {
    name: 'Сортировочно-перегрузочные станции и линии сортировки (досортировки) отходов, всего',
    number: 40,
    values: range(0, 5),
  },
  {
    name: '- из них введено в эксплуатацию в отчетном году',
    number: 41,
    values: range(5, 10),
  },
  {
    name: 'Заводы по переработке ТКО, всего',
    number: 42,
    values: range(10, 15),
  },
  {
    name: '- из них введено в эксплуатацию в отчетном году',
    number: 43,
    values: range(15, 20),
  },
])

const foo = () => console.log(data.value)
</script>

<style>
.cell {
  vertical-align: top;
  border: 1px solid;
}
</style>
