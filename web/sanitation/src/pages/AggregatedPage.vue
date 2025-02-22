<template>
  <div class="heading">
    <div>РАЗДЕЛ IV.</div>
    <div>ОБЪЕКТЫ СОРТИРОВКИ И ПЕРЕРАБОТКИ ТВЕРДЫХ КОММУНАЛЬНЫХ ОТХОДОВ. За 2025 по</div>
  </div>

  <div class="row">
    <q-select
      class="col"
      label="Область"
      :options="regions"
      :option-label="(x) => x.name"
      :option-value="(x) => x.id"
      v-model="selectedRegion"
      map-options
      emit-value
    ></q-select>
    <q-select
      class="col"
      label="Район"
      clearable
      :options="districts"
      :option-label="(x) => x.name"
      :option-value="(x) => x.id"
      v-model="selectedDistrict"
      map-options
      emit-value
    ></q-select>
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
        <td class="cell text-center" v-for="value in row.values" :key="value.toString()">
          {{ data[value] }}
        </td>
      </tr>
    </tbody>
  </table>
  <q-page padding class="page-with-table"> </q-page>
</template>

<script setup>
import { ref, onMounted, watch } from 'Vue'
import { api } from '../boot/axios'

const regions = ref([])
const data = ref([])
const districts = ref([])

const selectedDistrict = ref()
const selectedRegion = ref()

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

const getDictionary = async (type) => {
  let responce = await api.get('/api/Values/GetDictitonary?type=' + type)
  return responce.data
}

const getAggregated = async () => {
  let responce = await api.get('/api/Values/GetAggregated', {
    params: {
      regionId: selectedRegion.value,
      districtId: selectedDistrict.value ?? null,
      year: 2025,
    },
  })
  return responce.data
}

onMounted(async () => {
  regions.value = await getDictionary(2)
  districts.value = await getDictionary(3)
})

watch([selectedRegion, selectedDistrict], async () => {
  if (selectedRegion.value) {
    let responce = await getAggregated()
    if (responce?.values) {
      data.value = responce.values
    } else {
      data.value = []
    }
  }
})
</script>
<style>
.cell {
  vertical-align: top;
  border: 1px solid;
}
</style>
