<template>
  <div class="heading">
    <div>ПРИЛОЖЕНИЕ 3</div>
    <div>
      Информация об объектах сортировки, использования и захоронения твердых коммунальных отходов
    </div>
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
  </div>
  <!-- Table -->
  <table class="row" style="border: 1px solid; border-collapse: collapse">
    <tbody>
      <tr>
        <th rowspan="2" class="cell text-center">
          Наименование административно-территориальных единиц
        </th>
        <th colspan="5" class="cell text-center">
          Пункты сортировки (досортировки) твердых коммунальных отходов (далее – ТКО) и вторичных
          материальных ресурсов (далее –ВМР)
        </th>
        <th colspan="5" class="cell text-center">Заводы по переработке ТКО</th>
      </tr>
      <tr>
        <th class="cell text-center">количество объектов, единиц</th>
        <th class="cell text-center">установленная мощность, тыс. тонн в год</th>
        <th class="cell text-center">пропущено ТКО, тыс. тонн</th>
        <th class="cell text-center">отобрано ВМР, тыс. тонн</th>
        <th class="cell text-center">направлено ТКО на захоронение, тыс. тонн</th>
        <th class="cell text-center">количество объектов, единиц</th>
        <th class="cell text-center">установленная мощность, тыс. тонн в год</th>
        <th class="cell text-center">пропущено ТКО, тыс. тонн</th>
        <th class="cell text-center">отобрано ВМР, тыс. тонн</th>
        <th class="cell text-center">направлено ТКО на захоронение, тыс. тонн</th>
      </tr>
      <tr v-for="row in data" :key="row.name">
        <td class="cell text-center">{{ row.name }}</td>
        <td class="cell text-center">{{ row.sorting_sites }}</td>
        <td class="cell text-center">{{ row.sorting_capacity }}</td>
        <td class="cell text-center">{{ row.sorting_processed }}</td>
        <td class="cell text-center">{{ row.sorting_collected }}</td>
        <td class="cell text-center">{{ row.sorting_dumped }}</td>
        <td class="cell text-center">{{ row.recycling_sites }}</td>
        <td class="cell text-center">{{ row.recycling_capacity }}</td>
        <td class="cell text-center">{{ row.recycling_processed }}</td>
        <td class="cell text-center">{{ row.recycling_collected }}</td>
        <td class="cell text-center">{{ row.recycling_dumped }}</td>
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

const selectedRegion = ref()

const getDictionary = async (type) => {
  let responce = await api.get('/api/Values/GetDictitonary?type=' + type)
  return responce.data
}

const getSummary = async () => {
  let responce = await api.get('/api/Values/GetSummary', {
    params: {
      regionId: selectedRegion.value,
      year: 2025,
    },
  })
  return responce.data
}

onMounted(async () => {
  regions.value = await getDictionary(2)
})

watch([selectedRegion], async () => {
  if (selectedRegion.value) {
    let responce = await getSummary()
    if (responce?.data) {
      data.value = responce.data
    } else {
      data.value = []
    }
  }
})
</script>
<style>
.cell text-center {
  vertical-align: top;
  border: 1px solid;
}
</style>
