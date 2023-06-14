using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LoadingAnim : MonoBehaviour
{
    [SerializeField] List<Image> Icons;
    [SerializeField] GameObject LoadingObj;

    private void Start()
    {
        FirstInitialize();
    }

    void FirstInitialize()
    {
        LoadingObj.SetActive(false);
    }

    public void OnInitialized()
    {
        DOTween.Sequence()
               .AppendCallback(() =>
               {
                   LoadingObj.SetActive(true);
                   foreach (var iconlist in Icons)
                   {
                       iconlist.transform.DOScale(0, 0);
                   }
               })
               .AppendInterval(2)
               .AppendCallback(() => StartAnimation());
    }

    public void StartAnimation()
    {
        DOTween.Sequence()
               .AppendInterval(1)
               .AppendCallback(() =>
               {
                   for (int i = 0; i < Icons.Count; i++)
                   {
                       Icons[i].transform.DOScale(1, 0.4f)
                                         .SetEase(Ease.InFlash)
                                         .SetDelay(i);
                   }
               })
               .AppendInterval(Icons.Count)
               .AppendCallback(() =>
               {
                   foreach(var iconlist in Icons)
                   {
                       iconlist.transform.DOScale(0,0.5f);
                   }
               }).SetLoops(-1);
    }

    public void EndAnimation()
    {
        LoadingObj.SetActive(false);
    }
}
